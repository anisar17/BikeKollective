import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/issue.dart';
import 'package:bike_kollective/data/model/ride.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/user_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the ride in progress by the active user, null if no ride is in progress
final activeRideProvider = StateNotifierProvider<ActiveRideNotifier, RideModel?>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  final locAccess = ref.watch(userLocationProvider);
  final activeUser = ref.watch(activeUserProvider);
  return ActiveRideNotifier(dbAccess, locAccess, activeUser); 
});

// The active ride is handled by this class
// Note: there can only be one active ride at a time for a given user
class ActiveRideNotifier extends StateNotifier<RideModel?> {
  final BKDB dbAccess;
  final UserLocation locAccess;
  final UserModel? activeUser;
  ActiveRideNotifier(this.dbAccess, this.locAccess, this.activeUser) : super(null);

  void refresh() {
    // Update the local active ride with any active ride from the database
    if(activeUser == null) {
      state = null;
    } else {
      dbAccess.getActiveRideForUser(activeUser!)
      .then((maybeRide) {
        state = maybeRide;
      })
      .catchError((error) {
        // TODO - send database error notification to error notifier?
        state = null;
      });
    }
  }

  void startRide(BikeModel bike) {
    if(activeUser == null) {
      // Can't start a ride without a logged in rider
      // TODO - send error to error notifier?
    }
    else if(state != null) {
      // Can only have one active ride at a time
      // TODO - send error to error notifier?
    }
    else {
      // TODO - implement
    }
  }

  void finishRide() {
    // End a ride normally
    // TODO - implement
  }

  void reportIssue(IssueModel issue) {
    // End a ride because of an issue reported mid-ride
    // TODO - implement
  }
}
