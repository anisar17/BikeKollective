import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/issue.dart';
import 'package:bike_kollective/data/provider/active_ride.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/user_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides list of available bikes near the user
final availableBikesProvider = StateNotifierProvider<AvailableBikesNotifier, List<BikeModel>>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  final locAccess = ref.watch(userLocationProvider);
  return AvailableBikesNotifier(ref, dbAccess, locAccess);
});

// The available bike search is handled by this class
class AvailableBikesNotifier extends StateNotifier<List<BikeModel>> {
  final Ref ref;
  final BKDB dbAccess;
  final UserLocation locAccess;
  AvailableBikesNotifier(this.ref, this.dbAccess, this.locAccess) : super([]);

  void refresh() {
    // Update the list of available bikes based on user's location and bike database
    locAccess.getCurrent()
    .then((point) {
      dbAccess.getAvailableBikesNearPoint(point)
      .then((bikes) {
        state = bikes;
      })
      .catchError((error) {
        // TODO - send database error notification to error notifier?
        state = [];
      });
    })
    .catchError((error) {
      // TODO - send user location error notification to error notifier?
      state = [];
    });
  }

  void reportBike(IssueModel issue) {
    // Report an issue with a bike that isn't being ridden
    dbAccess.addIssue(issue)
    .then((issue) {
      // Remove the reported bike from the available list
      state = [...state.where((b) {return b.docRef != issue.bike;})];
    })
    .catchError((error) {
      // TODO - send database error notification to error notifier?
    });
  }

  void checkoutBike(BikeModel bike) {
    // Checkout a bike for the active user to ride
    ref.read(activeRideProvider.notifier).startRide(bike);
  }
}
