import 'package:bike_kollective/data/model/app_error.dart';
import 'package:bike_kollective/data/model/bike.dart';
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
      state = await dbAccess.getBikesOwnedByUser(activeUser!);
    } catch (e) {
      errorNotifier.report(AppError(
          category: ErrorCategory.database,
          displayMessage: "Could not get owned bikes",
          logMessage: "Could not get owned bikes: $e"));
      state = [];
      rethrow;
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
        rethrow;
      }
    } catch (e) {
      errorNotifier.report(AppError(
          category: ErrorCategory.location,
          displayMessage: "Could not get user location",
          logMessage: "Could not get user location: $e"));
      rethrow;
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
        imageUrl: newImageLocalPath,
      ));
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
      rethrow;
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
      rethrow;
    }
  }
}
