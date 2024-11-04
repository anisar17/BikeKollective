import 'package:flutter/material.dart';
import 'package:bike_kollective/data/model/bike.dart';
import "package:bike_kollective/data/model/bk_document_reference.dart";
import "package:bike_kollective/data/model/bk_geo_point.dart";

var fakeUserRef = BKDocumentReference.fake("fakeUserId");

var availableBikes = [
  BikeModel(
    docRef: null,
    owner: fakeUserRef,
    name: "Trek Road Bike",
    type: BikeType.road,
    description: "Good road bike for cruising around town.",
    code: "1234",
    imageUrl:
        "https://c02.purpledshub.com/uploads/sites/39/2023/05/Trek-Emonda-AL5-02-2406262.jpg?w=1240&webp=1",
    status: BikeStatus.available,
    locationPoint: const BKGeoPoint(44.5646, -123.2620), // Downtown Corvallis
    locationUpdated: DateTime.now(),
    rides: [],
    issues: [],
  ),
  BikeModel(
    docRef: null,
    owner: fakeUserRef,
    name: "Specialized Mountain Bike",
    type: BikeType.mountain,
    description:
        "Great mountain bike for shredding trails and tearing up jumps.",
    code: "1234",
    imageUrl:
        "https://bikepacking.com/wp-content/uploads/2020/05/2021-specialized-rockhopper-2-2000x1333.jpg",
    status: BikeStatus.available,
    locationPoint: const BKGeoPoint(44.5656, -123.2775), // Near OSU Campus
    locationUpdated: DateTime.now(),
    rides: [],
    issues: [],
  ),
  BikeModel(
    docRef: null,
    owner: fakeUserRef,
    name: "Chill Beach Cruiser",
    type: BikeType.road,
    description:
        "Beach cruiser for a leisurely ride. Great for cruising around town.",
    code: "1234",
    imageUrl:
        "https://www.beachbikes.net/cdn/shop/products/f_urban_m_7_black_1024x1024.jpg?v=1482298636",
    status: BikeStatus.available,
    locationPoint: const BKGeoPoint(44.5631, -123.2793), // Central Park
    locationUpdated: DateTime.now(),
    rides: [],
    issues: [],
  ),
  BikeModel(
    docRef: null,
    owner: fakeUserRef,
    name: "Tandem Mountain Bike",
    type: BikeType.tandem,
    description:
        "Awesome tandem mountain bike for hitting the trails with a friend or just cruising around town.",
    code: "1234",
    imageUrl:
        "https://images.squarespace-cdn.com/content/v1/569e5cb8bfe8737de92ed0d2/1652375207957-Q54Q0YUK7TY7N8CVBEAQ/TrekT900Tandem_preview.jpg?format=750w",
    status: BikeStatus.available,
    locationPoint:
        const BKGeoPoint(44.5668, -123.2632), // Riverfront Commemorative Park
    locationUpdated: DateTime.now(),
    rides: [],
    issues: [],
  ),
  BikeModel(
    docRef: null,
    owner: fakeUserRef,
    name: "Urban City Bike",
    type: BikeType.road,
    description: "Smooth ride for city commuting and leisure.",
    code: "1234",
    imageUrl:
        "https://c02.purpledshub.com/uploads/sites/39/2023/05/Trek-Emonda-AL5-02-2406262.jpg?w=1240&webp=1",
    status: BikeStatus.available,
    locationPoint:
        const BKGeoPoint(44.5682, -123.2600), // Near the Farmers' Market area
    locationUpdated: DateTime.now(),
    rides: [],
    issues: [],
  ),
  BikeModel(
    docRef: null,
    owner: fakeUserRef,
    name: "Specialized Hardtail MTB",
    type: BikeType.mountain,
    description: "Ideal for dirt trails and rugged terrain.",
    code: "1234",
    imageUrl:
        "https://bikepacking.com/wp-content/uploads/2020/05/2021-specialized-rockhopper-2-2000x1333.jpg",
    status: BikeStatus.available,
    locationPoint: const BKGeoPoint(44.5672, -123.2800), // Willamette Park
    locationUpdated: DateTime.now(),
    rides: [],
    issues: [],
  ),
  BikeModel(
    docRef: null,
    owner: fakeUserRef,
    name: "Vintage Cruiser",
    type: BikeType.road,
    description: "Classic bike for a comfortable ride around town.",
    code: "1234",
    imageUrl:
        "https://www.beachbikes.net/cdn/shop/products/f_urban_m_7_black_1024x1024.jpg?v=1482298636",
    status: BikeStatus.available,
    locationPoint: const BKGeoPoint(44.5615, -123.2731), // Riverbend Park
    locationUpdated: DateTime.now(),
    rides: [],
    issues: [],
  ),
  BikeModel(
    docRef: null,
    owner: fakeUserRef,
    name: "Trail Blazer",
    type: BikeType.mountain,
    description: "Tough and ready for mountain trails.",
    code: "1234",
    imageUrl:
        "https://images.squarespace-cdn.com/content/v1/569e5cb8bfe8737de92ed0d2/1652375207957-Q54Q0YUK7TY7N8CVBEAQ/TrekT900Tandem_preview.jpg?format=750w",
    status: BikeStatus.available,
    locationPoint: const BKGeoPoint(44.5592, -123.2645), // Close to Sunset Park
    locationUpdated: DateTime.now(),
    rides: [],
    issues: [],
  ),
];
