import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/bk_document_reference.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/owned_bikes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'mocks.dart';
import 'riverpod_test_utils.dart';

void main() {
  test('initial refresh with success', () async {
    var fakeUserRef = BKDocumentReference.fake("FAKEUSER");
    var fakeBikeRef = BKDocumentReference.fake("FAKEBIKE");
    final fakeBikes = [
      BikeModel(
      docRef: fakeBikeRef,
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
    )
    ];
    final fakeUser = UserModel(
      docRef: fakeUserRef,
      uid: "FAKEUID",
      verified: DateTime.now(),
      agreed: DateTime.now(),
      banned: null,
      points: 0);
    final mdb = MockBKDB();
    final mau = MockActiveUserNotifier(fakeUser);
    when(() => mdb.getBikesOwnedByUser(fakeUser)).thenAnswer((_) => Future<List<BikeModel>>.delayed(Duration(milliseconds: 10), () {return fakeBikes;}));
    final container = createContainer(
      // Override the provider to have it create our mocks
      overrides: [
        databaseProvider.overrideWith((ref) {return mdb;}),
        activeUserProvider.overrideWith((ref) {return mau;})
      ]
    );
    // Prevent auto dispose of provider and run provider function
    final ownedBikesSubscription = container.listen<List<BikeModel>>(ownedBikesProvider, (_, __) {});
    final ownedBikesNotifier = container.read(ownedBikesProvider.notifier);
    await ownedBikesNotifier.refresh();
    var readBikes = ownedBikesSubscription.read();
    expect(
      readBikes,
      fakeBikes,
    );
    verify(() => mdb.getBikesOwnedByUser(fakeUser)).called(1);
  });
}