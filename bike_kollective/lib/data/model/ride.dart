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
  final DocumentReference rider;
  final DocumentReference bike;
  final GeoPoint startPoint;
  final DateTime startTime;
  final GeoPoint? finishPoint;
  final DateTime? finishTime;
  final RideReview? review;

  const RideModel({
    required this.rider,
    required this.bike,
    required this.startPoint,
    required this.startTime,
    required this.finishPoint,
    required this.finishTime,
    required this.review,
  });

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
