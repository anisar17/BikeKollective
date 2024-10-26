import "package:cloud_firestore/cloud_firestore.dart";

enum BikeStatus { available, inUse, hasIssue }

enum BikeType { road, mountain, electric, tandem, kids }

// Bike data, format version 1
class BikeModel {
  final DocumentReference? docRef;
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
    required this.docRef,
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

  factory BikeModel.newBike({
    required DocumentReference owner,
    required String name,
    required BikeType type,
    required String description,
    required String code,
    required String imageLocalPath,
    required GeoPoint startingPoint,
    }) {
    // Start the bike
    return BikeModel(
      docRef: null,
      owner: owner,
      name: name,
      type: type,
      description: description,
      code: code,
      imageUrl: imageLocalPath,
      status: BikeStatus.available,
      locationPoint: startingPoint,
      locationUpdated: DateTime.now(),
      rides: [],
      issues: []
    );
  }

  factory BikeModel.fromMap(Map<String, dynamic> map, {required DocumentReference? docRef}) {
    return BikeModel(
      docRef: docRef,
      owner: map["owner"],
      name: map["name"],
      type: map["type"],
      description: map["description"],
      code: map["code"],
      imageUrl: map["imageUrl"],
      status: map["status"],
      locationPoint: map["locationPoint"],
      locationUpdated: map["locationUpdated"],
      rides: map["rides"],
      issues: map["issues"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "owner": owner,
      "name": name,
      "type": type,
      "description": description,
      "code": code,
      "imageUrl": imageUrl,
      "status": status,
      "locationPoint": locationPoint,
      "locationUpdated": locationUpdated,
      "rides": rides,
      "issues": issues
    };
  }

  bool isFromDatabase() {
    return (docRef != null);
  }
}
