import 'package:cloud_firestore/cloud_firestore.dart';

enum BikeStatus { available, inUse, hasIssue }

enum BikeType { road, mountain, electric, tandem, kids }

// Bike data, format version 1
class BikeModel {
  final DocumentReference owner;
  final String name;
  final BikeType type;
  final String description;
  final String code;
  final String imageUrl;
  final BikeStatus status;
  final GeoPoint locationPoint;
  final DateTime locationUpdated;
  final List<DocumentReference> rides;
  final List<DocumentReference> issues;

  const BikeModel({
    required this.owner,
    required this.name,
    required this.type,
    required this.description,
    required this.code,
    required this.imageUrl,
    required this.status,
    required this.locationPoint,
    required this.locationUpdated,
    required this.rides,
    required this.issues,
  });
}
