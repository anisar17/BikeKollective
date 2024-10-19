import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/user_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides list of available bikes near the user
final availableBikesProvider = StateNotifierProvider<AvailableBikesNotifier, List<BikeModel>>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  final locAccess = ref.watch(userLocationProvider);
  return AvailableBikesNotifier(dbAccess, locAccess);
});

// The available bike search is handled by this class
class AvailableBikesNotifier extends StateNotifier<List<BikeModel>> {
  final BKDB dbAccess;
  final UserLocation locAccess;
  AvailableBikesNotifier(this.dbAccess, this.locAccess) : super([]);

  void refresh() {
    // Update the list of available bikes based on user's location and bike database
    // TODO - implement and handle errors
  }
}