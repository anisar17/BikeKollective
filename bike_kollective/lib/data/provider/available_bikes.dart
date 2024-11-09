import 'package:bike_kollective/data/model/app_error.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/issue.dart';
import 'package:bike_kollective/data/provider/active_ride.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/reported_app_errors.dart';
import 'package:bike_kollective/data/provider/user_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides list of available bikes near the user
final availableBikesProvider = StateNotifierProvider<AvailableBikesNotifier, List<BikeModel>>((ref) {
  ref.keepAlive();
  final dbAccess = ref.watch(databaseProvider);
  final locAccess = ref.watch(userLocationProvider);
  final errorNotifier = ref.watch(errorProvider.notifier);
  final activeRideNotifier = ref.watch(activeRideProvider.notifier);
  return AvailableBikesNotifier(dbAccess, locAccess, errorNotifier, activeRideNotifier);
});

// The available bike search is handled by this class
class AvailableBikesNotifier extends StateNotifier<List<BikeModel>> {
  final BKDB dbAccess;
  final UserLocation locAccess;
  final ErrorNotifier errorNotifier;
  final ActiveRideNotifier activeRideNotifier;
  AvailableBikesNotifier(this.dbAccess, this.locAccess, this.errorNotifier, this.activeRideNotifier) : super([]);

  Future<void> refresh() async {
    // Update the list of available bikes based on user's location and bike database
    try {
      var point = await locAccess.getCurrent();
      try {
        state = await dbAccess.getAvailableBikesNearPoint(point);
      } catch(e) {
        errorNotifier.report(AppError(
          category: ErrorCategory.database,
          displayMessage: "Could not get available bikes",
          logMessage: "Could not get available bikes: $e"));
        state = [];
      }
    } catch(e) {
      errorNotifier.report(AppError(
        category: ErrorCategory.location,
        displayMessage: "Could not get user location",
        logMessage: "Could not get user location: $e"));
      state = [];
    }
  }

  Future<void> reportBike(IssueModel issue) async {
    // Report an issue with a bike that isn't being ridden
    try {
      await dbAccess.addIssue(issue);
      // Remove the reported bike from the available list
      state = [...state.where((b) {return b.docRef != issue.bike;})];
    } catch(e) {
      errorNotifier.report(AppError(
        category: ErrorCategory.database,
        displayMessage: "Could not report issue",
        logMessage: "Could not report issue: $e"));
    }
  }

  Future<void> checkoutBike(BikeModel bike) async {
    // Checkout a bike for the active user to ride
    await activeRideNotifier.startRide(bike);
  }
}
