import 'package:bike_kollective/data/model/app_error.dart';
import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/issue.dart';
import 'package:bike_kollective/data/model/ride.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/reported_app_errors.dart';
import 'package:bike_kollective/data/provider/user_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the ride in progress by the active user, null if no ride is in progress
final activeRideProvider = StateNotifierProvider<ActiveRideNotifier, RideModel?>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  final locAccess = ref.watch(userLocationProvider);
  final errorNotifier = ref.watch(errorProvider.notifier);
  final activeUser = ref.watch(activeUserProvider);
  return ActiveRideNotifier(dbAccess, locAccess, errorNotifier, activeUser); 
});

// The active ride is handled by this class
// Note: there can only be one active ride at a time for a given user
class ActiveRideNotifier extends StateNotifier<RideModel?> {
  final BKDB dbAccess;
  final UserLocation locAccess;
  final ErrorNotifier errorNotifier;
  final UserModel? activeUser;
  ActiveRideNotifier(this.dbAccess, this.locAccess, this.errorNotifier, this.activeUser) : super(null);

  Future<void> refresh() async {
    // Update the local active ride with any active ride from the database
    if(activeUser == null) {
      state = null;
    } else {
      try {
        state = await dbAccess.getActiveRideForUser(activeUser!);
      } catch(e) {
        errorNotifier.report(AppError(
          category: ErrorCategory.database,
          displayMessage: "Could not get active ride",
          logMessage: "Could not get active ride: $e"));
        state = null;
      }
    }
  }

  Future<void> startRide(BikeModel bike) async {
    if(activeUser == null) {
      errorNotifier.report(AppError(
        category: ErrorCategory.state,
        displayMessage: null,
        logMessage: "Can't start a ride without a logged in rider"));
    }
    else if(state != null) {
      errorNotifier.report(AppError(
        category: ErrorCategory.state,
        displayMessage: null,
        logMessage: "Can only have one active ride at a time"));
    }
    else {
      // TODO - implement
    }
  }

  Future<void> finishRide() async {
    // End a ride normally
    // TODO - implement
  }

  Future<void> reportIssue(IssueModel issue) async {
    // End a ride because of an issue reported mid-ride
    // TODO - implement
  }
}
