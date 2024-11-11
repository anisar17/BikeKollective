import 'package:bike_kollective/data/model/app_error.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/bk_document_reference.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/reported_app_errors.dart';
import 'package:bike_kollective/data/provider/user_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides list of bikes owned by the user
final ownedBikesProvider =
    StateNotifierProvider<OwnedBikesNotifier, List<BikeModel>>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  final locAccess = ref.watch(userLocationProvider);
  final errorNotifier = ref.watch(errorProvider.notifier);
  final activeUser = ref.watch(activeUserProvider);
  return OwnedBikesNotifier(dbAccess, locAccess, errorNotifier, activeUser);
});

// The owned bikes are handled by this class
class OwnedBikesNotifier extends StateNotifier<List<BikeModel>> {
  final BKDB dbAccess;
  final UserLocation locAccess;
  final ErrorNotifier errorNotifier;
  final UserModel? activeUser;
  OwnedBikesNotifier(
      this.dbAccess, this.locAccess, this.errorNotifier, this.activeUser)
      : super([]);

  Future<void> refresh() async {
    try {
      if (activeUser == null) {
        state = [
          BikeModel(
            docRef: BKDocumentReference.fake("B1"),
            owner: BKDocumentReference.fake("U1"),
            name: "Trek Road Bike",
            type: BikeType.road,
            description: "Good road bike for cruising around town.",
            code: "1234",
            imageUrl:
                "https://c02.purpledshub.com/uploads/sites/39/2023/05/Trek-Emonda-AL5-02-2406262.jpg?w=1240&webp=1",
            status: BikeStatus.available,
            locationPoint: const BKGeoPoint(47.6062, 122.3328),
            locationUpdated: DateTime.now(),
            rides: [],
            issues: [],
          ),
          BikeModel(
            docRef: BKDocumentReference.fake("B2"),
            owner: BKDocumentReference.fake("U1"),
            name: "Specialized Mountain Bike",
            type: BikeType.mountain,
            description: "Great mountain bike for trails.",
            code: "5678",
            imageUrl:
                "https://bikepacking.com/wp-content/uploads/2020/05/2021-specialized-rockhopper-2-2000x1333.jpg",
            status: BikeStatus.available,
            locationPoint: const BKGeoPoint(47.6027, 122.3128),
            locationUpdated: DateTime.now(),
            rides: [],
            issues: [],
          ),
          BikeModel(
            docRef: BKDocumentReference.fake("B3"),
            owner: BKDocumentReference.fake("U1"),
            name: "Chill Beach Cruiser",
            type: BikeType.road,
            description: "Beach cruiser for a relaxed ride.",
            code: "9101",
            imageUrl:
                "https://www.beachbikes.net/cdn/shop/products/f_urban_m_7_black_1024x1024.jpg?v=1482298636",
            status: BikeStatus.available,
            locationPoint: const BKGeoPoint(47.6061, 122.3328),
            locationUpdated: DateTime.now(),
            rides: [],
            issues: [],
          ),
        ];
      } else {
        state = await dbAccess.getBikesOwnedByUser(activeUser!);
      }
    } catch (e) {
      errorNotifier.report(AppError(
          category: ErrorCategory.database,
          displayMessage: "Could not get owned bikes",
          logMessage: "Could not get owned bikes: $e"));
      state = [];
    }
  }

  Future<void> addBike(
      {required String name,
      required BikeType type,
      required String description,
      required String code,
      required String imageLocalPath}) async {
    // Note: this function should never be called before there is an active user
    try {
      var point = await locAccess.getCurrent();
      try {
        var newBike = await dbAccess.addBike(BikeModel.newBike(
            owner: activeUser!.docRef!,
            name: name,
            type: type,
            description: description,
            code: code,
            imageLocalPath: imageLocalPath,
            startingPoint: point));
        // Add the bike to the list (force state update)
        state = [newBike, ...state];
      } catch (e) {
        errorNotifier.report(AppError(
            category: ErrorCategory.database,
            displayMessage: "Could not add bike",
            logMessage: "Could not add bike: $e"));
      }
    } catch (e) {
      errorNotifier.report(AppError(
          category: ErrorCategory.location,
          displayMessage: "Could not get user location",
          logMessage: "Could not get user location: $e"));
    }
  }

  Future<void> updateBikeDetails(BikeModel bike,
      {String? newName,
      BikeType? newType,
      String? newDescription,
      String? newCode,
      String? newImageLocalPath}) async {
    try {
      var updatedBike = await dbAccess.updateBike(bike.copyWith(
          name: newName,
          type: newType,
          description: newDescription,
          code: newCode,
          imageUrl: newImageLocalPath));
      // Update the bike in the list (force state update)
      state = state.map((b) {
        if (b.docRef == updatedBike.docRef) {
          return updatedBike;
        }
        return b;
      }).toList();
    } catch (e) {
      errorNotifier.report(AppError(
          category: ErrorCategory.database,
          displayMessage: "Could not update bike",
          logMessage: "Could not update bike: $e"));
    }
  }

  Future<void> removeBike(BikeModel bike) async {
    // Delete existing bike
    try {
      await dbAccess.deleteBike(bike);
      // Remove the bike from the list
      state = [
        ...state.where((b) {
          return b != bike;
        })
      ];
    } catch (e) {
      errorNotifier.report(AppError(
          category: ErrorCategory.database,
          displayMessage: "Could not delete bike",
          logMessage: "Could not delete bike: $e"));
    }
  }
}
