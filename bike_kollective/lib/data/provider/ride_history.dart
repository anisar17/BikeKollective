import 'package:bike_kollective/data/model/app_error.dart';
import 'package:bike_kollective/data/model/ride.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/reported_app_errors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides history of rides taken by the active user, both past and active rides
final rideHistoryProvider = StateNotifierProvider<RideHistoryNotifier, List<RideModel>>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  final errorNotifier = ref.watch(errorProvider.notifier);
  final activeUser = ref.watch(activeUserProvider);
  return RideHistoryNotifier(dbAccess, errorNotifier, activeUser);  
});

// The ride history is handled by this class
class RideHistoryNotifier extends StateNotifier<List<RideModel>> {
  final BKDB dbAccess;
  final ErrorNotifier errorNotifier;
  final UserModel? activeUser;
  RideHistoryNotifier(this.dbAccess, this.errorNotifier, this.activeUser) : super([]);

  Future<void> refresh() async {
    // Update the local list of taken rides from the database
    // TODO - add count limit/date limit/pagination to prevent big request?
    if(activeUser == null) {
      state = [];
    } else {
      try {
        state = await dbAccess.getRidesTakenByUser(activeUser!);
      } catch(e) {
        errorNotifier.report(AppError(
          category: ErrorCategory.database,
          displayMessage: "Could not get active ride",
          logMessage: "Could not get active ride: $e"));
        state = [];
        rethrow;
      }
    }
  }
}
