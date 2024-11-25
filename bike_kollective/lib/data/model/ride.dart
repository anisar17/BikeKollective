import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/bk_document_reference.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:bike_kollective/data/model/user.dart';

enum RideReviewTag { 
  funToRide, wellMaintained, fast, comfortable, looksGood,
  brokeDown, uncomfortable, needsATuneUp, tooSlow
}

// The user should finish the ride before 8 hours have passed
// to avoid a warning message
const lateDuration = Duration(hours: 8);
// The user MUST finish the ride before 24 hours have passed
// to avoid violating the agreement
const violationDuration = Duration(hours: 24);

// Review data for ride, Ride format version 1
class RideReview {
  final int stars;
  final List<RideReviewTag> tags;
  final String comment;
  final DateTime submitted;

  const RideReview({
    required this.stars,
    required this.tags,
    required this.comment,
    required this.submitted,
  });

  factory RideReview.fromMap(Map<String, dynamic> map) {
    return RideReview(
      stars: map["stars"],
      tags: map["tags"].map<RideReviewTag>((name) => RideReviewTag.values.byName(name)).toList(),
      comment: map["startPoint"],
      submitted: map["startTime"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "stars": stars,
      "tags": tags.map((tag) => tag.name).toList(),
      "comment": comment,
      "submitted": submitted,
    };
  }
}

// Ride data, format version 1
class RideModel {
  final BKDocumentReference? docRef;
  final BKDocumentReference rider;
  final BKDocumentReference bike;
  final BKGeoPoint startPoint;
  final DateTime startTime;
  final BKGeoPoint? finishPoint;
  final DateTime? finishTime;
  final RideReview? review;

  const RideModel({
    required this.docRef,
    required this.rider,
    required this.bike,
    required this.startPoint,
    required this.startTime,
    required this.finishPoint,
    required this.finishTime,
    required this.review,
  });

  factory RideModel.newRide({
    required UserModel rider,
    required BikeModel bike
    }) {
    // Start the ride
    return RideModel(
    docRef: null,
    rider: rider.docRef!,
    bike: bike.docRef!,
    startPoint: bike.locationPoint,
    startTime: DateTime.now(),
    finishPoint: null,
    finishTime: null,
    review: null,
    );
  }

  factory RideModel.fromMap(Map<String, dynamic> map, {required BKDocumentReference? docRef}) {
    return RideModel(
      docRef: docRef,
      rider: map["rider"],
      bike: map["bike"],
      startPoint: map["startPoint"],
      startTime: map["startTime"],
      finishPoint: map["finishPoint"],
      finishTime: map["finishTime"],
      review: (map["review"] != null) ? RideReview.fromMap(map["review"]) : null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "rider": rider,
      "bike": bike,
      "startPoint": startPoint,
      "startTime": startTime,
      "finishPoint": finishPoint,
      "finishTime": finishTime,
      "review": review?.toMap()
    };
  }

  RideModel copyWith({
    BKDocumentReference? docRef,
    BKDocumentReference? rider,
    BKDocumentReference? bike,
    BKGeoPoint? startPoint,
    DateTime? startTime,
    BKGeoPoint? finishPoint,
    DateTime? finishTime,
    RideReview? review
  }) {
    // Make a copy with data changes
    return RideModel(
      docRef: docRef ?? this.docRef,
      rider: rider ?? this.rider,
      bike: bike ?? this.bike,
      startPoint: startPoint ?? this.startPoint,
      startTime: startTime ?? this.startTime,
      finishPoint: finishPoint ?? this.finishPoint,
      finishTime: finishTime ?? this.finishTime,
      review: review ?? this.review
    );
  }

  bool isFromDatabase() {
    return (docRef != null);
  }

  bool isFinished() {
    return (finishTime != null);
  }

  Duration getDuration() {
    if(isFinished()) {
      return finishTime!.difference(startTime);
    } else {
      return DateTime.now().difference(startTime);
    }
  }

  Duration getRemaining() {
    var duration = getDuration();
    if(duration >= lateDuration) {
      // No time remaining
      return const Duration();
    } else {
      // Some time remaining
      return lateDuration - duration;
    }
  }

  bool isLate() {
    return getDuration() > lateDuration;
  }

  bool isViolation() {
    return getDuration() > violationDuration;
  }

  bool isReviewed() {
    return (review != null);
  }
}
