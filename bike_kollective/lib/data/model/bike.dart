import 'package:bike_kollective/data/model/bk_document_reference.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';

enum BikeStatus { available, inUse, hasIssue }

final Map<BikeStatus, String> bikeStatusDisplayNames = {
  BikeStatus.available: 'Available',
  BikeStatus.inUse: 'In Use',
  BikeStatus.hasIssue: 'Has Issue',
};

enum BikeType { road, mountain, electric, tandem, kids }

final Map<BikeType, String> bikeTypeDisplayNames = {
  BikeType.road: 'Road',
  BikeType.mountain: 'Mountain',
  BikeType.electric: 'Electric',
  BikeType.tandem: 'Tandem',
  BikeType.kids: 'Kids'
};

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
  final int totalStars;
  final int totalReviews;

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
    required this.totalStars,
    required this.totalReviews,
  });

  factory BikeModel.newBike({
    required BKDocumentReference owner,
    required String name,
    required BikeType type,
    required String description,
    required String code,
    required String imageUrl,
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
      imageUrl: imageUrl,
      status: BikeStatus.available,
      locationPoint: startingPoint,
      locationUpdated: DateTime.now(),
      totalStars: 0,
      totalReviews: 0,
    );
  }

  factory BikeModel.fromMap(Map<String, dynamic> map,
      {required BKDocumentReference? docRef}) {
    return BikeModel(
      docRef: docRef,
      owner: map["owner"],
      name: map["name"],
      type: BikeType.values.byName(map["type"]),
      description: map["description"],
      code: map["code"],
      imageUrl: map["imageUrl"],
      status: BikeStatus.values.byName(map["status"]),
      locationPoint: map["locationPoint"],
      locationUpdated: map["locationUpdated"],
      totalStars: map["totalStars"],
      totalReviews: map["totalReviews"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "owner": owner,
      "name": name,
      "type": type.name,
      "description": description,
      "code": code,
      "imageUrl": imageUrl,
      "status": status.name,
      "locationPoint": locationPoint,
      "locationUpdated": locationUpdated,
      "totalStars": totalStars,
      "totalReviews": totalReviews,
    };
  }

  BikeModel copyWith({
    BKDocumentReference? docRef,
    BKDocumentReference? owner,
    String? name,
    BikeType? type,
    String? description,
    String? code,
    String? imageUrl,
    BikeStatus? status,
    BKGeoPoint? locationPoint,
    DateTime? locationUpdated,
    int? totalStars,
    int? totalReviews,
  }) {
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
      totalStars: totalStars ?? this.totalStars,
      totalReviews: totalReviews ?? this.totalReviews
    );
  }

  bool isFromDatabase() {
    return (docRef != null);
  }

  double? getRating() {
    // Returns the aggregate star rating, null if no ratings
    return (totalReviews > 0) ? (totalStars / totalReviews) : null;
  }
}
