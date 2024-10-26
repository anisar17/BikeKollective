import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum RideReviewTag { 
  funToRide, wellMaintained, fast, comfortable, looksGood,
  brokeDown, uncomfortable, needsATuneUp, tooSlow
}

// The user should finish the ride before 8 hours have passed
// to avoid a warning message
const lateMinutes = 8 * 60;
// The user MUST finish the ride before 24 hours have passed
// to avoid violating the agreement
const violationMinutes = 24 * 60;

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
}

// Ride data, format version 1
class RideModel {
  final DocumentReference? docRef;
  final DocumentReference rider;
  final DocumentReference bike;
  final GeoPoint startPoint;
  final DateTime startTime;
  final GeoPoint? finishPoint;
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

  factory RideModel.fromMap(Map<String, dynamic> map, {required DocumentReference? docRef}) {
    return RideModel(
      docRef: docRef,
      rider: map["rider"],
      bike: map["bike"],
      startPoint: map["startPoint"],
      startTime: map["startTime"],
      finishPoint: map["finishPoint"],
      finishTime: map["finishTime"],
      review: map["review"]
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
      "review": review
    };
  }

  bool isFromDatabase() {
    return (docRef != null);
  }

  bool isFinished() {
    return (finishTime != null);
  }

  int getDurationInMinutes() {
    if(isFinished()) {
      return finishTime!.difference(startTime).inMinutes;
    } else {
      return DateTime.now().difference(startTime).inMinutes;
    }
  }

  bool isLate() {
    return getDurationInMinutes() > lateMinutes;
  }

  bool isViolation() {
    return getDurationInMinutes() > violationMinutes;
  }

  bool isReviewed() {
    return (review != null);
  }
}
