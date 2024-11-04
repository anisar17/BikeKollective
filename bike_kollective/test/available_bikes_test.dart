import 'dart:io';

import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/bk_document_reference.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:bike_kollective/data/provider/available_bikes.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/user_location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'mocks.dart';
import 'riverpod_test_utils.dart';

void main() {
  test('initial refresh with success', () async {
    final mul = MockUserLocation();
    final mdb = MockBKDB();
    const fakeLoc = BKGeoPoint(47.6, 122.3);
    var fakeUserRef = BKDocumentReference.fake("FAKEUSER");
    final fakeBikes = [
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
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    )
    ];
    when(() => mul.getCurrent()).thenAnswer((_) => Future<BKGeoPoint>.delayed(Duration(milliseconds: 5), () {return fakeLoc;}));
    when(() => mdb.getAvailableBikesNearPoint(fakeLoc)).thenAnswer((_) => Future<List<BikeModel>>.delayed(Duration(milliseconds: 10), () {return fakeBikes;}));
    final container = createContainer(
      // Override the provider to have it create our mocks
      overrides: [
        userLocationProvider.overrideWith((ref) {return mul;}),
        databaseProvider.overrideWith((ref) {return mdb;})
      ]
    );
    // Prevent auto dispose of provider and run provider function
    final availableBikesSubscription = container.listen<List<BikeModel>>(availableBikesProvider, (_, __) {});
    final availableBikesNotifier = container.read(availableBikesProvider.notifier);
    await availableBikesNotifier.refresh();
    var readBikes = availableBikesSubscription.read();
    expect(
      readBikes,
      fakeBikes,
    );
    verify(() => mul.getCurrent()).called(1);
    verify(() => mdb.getAvailableBikesNearPoint(fakeLoc)).called(1);
  });
}