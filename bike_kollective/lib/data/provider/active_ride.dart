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

int getPointsForRider() {
  // Each ride earns the bike rider 10 points
  return 10;
}

int getPointsForOwner(RideReview review) {
  // Each ride earns the bike owner 10 points for each star above 1
  return (review.stars > 1) ? 10 * (review.stars - 1) : 0;
}

// The active ride is handled by this class
// Note: there can only be one active ride at a time for a given user
class ActiveRideNotifier extends StateNotifier<RideModel?> {
  final BKDB dbAccess;
  final UserLocation locAccess;
  final ErrorNotifier errorNotifier;
  final UserModel? activeUser;
  BikeModel? bike;
  ActiveRideNotifier(this.dbAccess, this.locAccess, this.errorNotifier, this.activeUser) : super(null);

  BikeModel? getBike() {
    return bike;
  }

  Future<void> refresh() async {
    // Update the local active ride with any active ride from the database
    if(activeUser == null) {
      state = null;
    } else {
      try {
        var ride = await dbAccess.getActiveRideForUser(activeUser!);
        if(ride != null) {
          bike = await dbAccess.getBikeByReference(ride.bike);
        }
        state = ride;
      } catch(e) {
        errorNotifier.report(AppError(
          category: ErrorCategory.database,
          displayMessage: "Could not get active ride",
          logMessage: "Could not get active ride: $e"));
        state = null;
        rethrow;
      }
    }
  }

  Future<void> startRide(BikeModel bike) async {
    if(activeUser == null) {
      errorNotifier.report(AppError(
        category: ErrorCategory.state,
        displayMessage: null,
        logMessage: "Can't start a ride without a signed in rider"));
      // TODO throw exception
    }
    else if(state != null) {
      errorNotifier.report(AppError(
        category: ErrorCategory.state,
        displayMessage: null,
        logMessage: "Can only have one active ride at a time"));
      // TODO throw exception
    }
    else {
      try {
        state = await dbAccess.addRide(RideModel.newRide(rider: activeUser!, bike: bike));
        // Change the bike status to in use, so it no longer appears in the available list
        await dbAccess.updateBike(bike.copyWith(status: BikeStatus.inUse));
        this.bike = bike;
      } catch(e) {
        errorNotifier.report(AppError(
          category: ErrorCategory.database,
          displayMessage: "Could not start ride",
          logMessage: "Could not start ride: $e"));
        rethrow;
      }
    }
  }

  Future<void> finishRide(RideReview review) async {
    if(state == null) {
      errorNotifier.report(AppError(
        category: ErrorCategory.state,
        displayMessage: null,
        logMessage: "Can only finish an active ride"));
      // TODO throw exception
    }
    else {
      try {
        var point = await locAccess.getCurrent();
        try {
          var time = DateTime.now();
          await dbAccess.updateRide(state!.copyWith(finishPoint: point, finishTime: time, review: review));
          // Update bike status to available, the bike location statistics,
          // and the bike rating statistics.
          bike = await dbAccess.getBikeByReference(state!.bike);
          await dbAccess.updateBike(bike!.copyWith(
            status: BikeStatus.available,
            locationPoint: point,
            locationUpdated: time,
            totalStars: bike!.totalStars + review.stars,
            totalReviews: bike!.totalReviews + 1));
          // Reward the bike rider (the current user) points
          await dbAccess.updateUser(activeUser!.copyWith(points: activeUser!.points + getPointsForRider()));
          // Reward the bike owner points
          var owner = await dbAccess.getUserByReference(bike!.owner);
          await dbAccess.updateUser(owner.copyWith(points: owner.points + getPointsForOwner(review)));
          // Ending a ride makes it no longer active
          bike = null;
          state = null;
        } catch(e) {
          errorNotifier.report(AppError(
            category: ErrorCategory.database,
            displayMessage: "Could not finish ride",
            logMessage: "Could not finish ride: $e"));
          rethrow;
        }
      } catch(e) {
        errorNotifier.report(AppError(
          category: ErrorCategory.location,
          displayMessage: "Could not get user location",
          logMessage: "Could not get user location: $e"));
        rethrow;
      }
    }
  }

  Future<void> reportIssue(IssueModel issue) async {
    // End a ride because of an issue reported mid-ride
    if(state == null) {
      errorNotifier.report(AppError(
        category: ErrorCategory.state,
        displayMessage: null,
        logMessage: "Can only report a ride issue for an active ride"));
      // TODO throw exception
    }
    else {
      try {
        var point = await locAccess.getCurrent();
        try {
          await dbAccess.updateRide(state!.copyWith(finishPoint: point, finishTime: DateTime.now()));
          await dbAccess.addIssue(issue);
          await dbAccess.updateBike(bike!.copyWith(status: BikeStatus.hasIssue));
          // Ending a ride makes it no longer active
          bike = null;
          state = null;
        } catch(e) {
          errorNotifier.report(AppError(
            category: ErrorCategory.database,
            displayMessage: "Could not finish ride",
            logMessage: "Could not finish ride: $e"));
          rethrow;
        }
      } catch(e) {
        errorNotifier.report(AppError(
          category: ErrorCategory.location,
          displayMessage: "Could not get user location",
          logMessage: "Could not get user location: $e"));
        rethrow;
      }
    }
  }
}
