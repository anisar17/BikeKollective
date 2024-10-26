import 'package:bike_kollective/data/model/ride.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides history of rides taken by the active user, both past and active rides
final rideHistoryProvider = StateNotifierProvider<RideHistoryNotifier, List<RideModel>>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  final activeUser = ref.watch(activeUserProvider);
  return RideHistoryNotifier(dbAccess, activeUser);  
});

// The ride history is handled by this class
class RideHistoryNotifier extends StateNotifier<List<RideModel>> {
  final BKDB dbAccess;
  final UserModel? activeUser;
  RideHistoryNotifier(this.dbAccess, this.activeUser) : super([]);

  void refresh() {
    // Update the local list of taken rides from the database
    // TODO - add count limit/date limit/pagination to prevent big request?
    if(activeUser == null) {
      state = [];
    } else {
      dbAccess.getRidesTakenByUser(activeUser!)
      .then((bikes) {
        state = bikes;
      })
      .catchError((error) {
        // TODO - send database error notification to error notifier?
        state = [];
      });
    }
  }
}
