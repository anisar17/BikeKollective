import 'package:bike_kollective/data/model/bk_document_reference.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';

enum BikeStatus { available, inUse, hasIssue }

enum BikeType { road, mountain, electric, tandem, kids }

// Bike data, format version 1
class BikeModel {
  final BKDocumentReference? docRef;
  final BKDocumentReference owner;
  final String name;
  final BikeType type;
  final String description;
  final String code;
  final String imageUrl;
  final BikeStatus status;
  final BKGeoPoint locationPoint;
  final DateTime locationUpdated;
  final List<BKDocumentReference> rides;
  final List<BKDocumentReference> issues;
  final double? distance; // Optional distance property

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
    this.distance,
  });

  factory BikeModel.newBike({
    required BKDocumentReference owner,
    required String name,
    required BikeType type,
    required String description,
    required String code,
    required String imageLocalPath,
    required BKGeoPoint startingPoint,
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
        issues: []);
  }

  factory BikeModel.fromMap(Map<String, dynamic> map,
      {required BKDocumentReference? docRef}) {
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
        issues: map["issues"]);
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

  BikeModel copyWith(
      {BKDocumentReference? docRef,
      BKDocumentReference? owner,
      String? name,
      BikeType? type,
      String? description,
      String? code,
      String? imageUrl,
      BikeStatus? status,
      BKGeoPoint? locationPoint,
      DateTime? locationUpdated,
      List<BKDocumentReference>? rides,
      List<BKDocumentReference>? issues,
      double? distance}) {
    // Make a copy with data changes
    return BikeModel(
        docRef: docRef ?? this.docRef,
        owner: owner ?? this.owner,
        name: name ?? this.name,
        type: type ?? this.type,
        description: description ?? this.description,
        code: code ?? this.code,
        imageUrl: imageUrl ?? this.imageUrl,
        status: status ?? this.status,
        locationPoint: locationPoint ?? this.locationPoint,
        locationUpdated: locationUpdated ?? this.locationUpdated,
        rides: rides ?? this.rides,
        issues: issues ?? this.issues,
        distance: distance ?? this.distance);
  }

  bool isFromDatabase() {
    return (docRef != null);
  }
}
