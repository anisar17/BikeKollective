import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:bike_kollective/data/provider/active_user.dart';
import 'package:bike_kollective/data/provider/database.dart';
import 'package:bike_kollective/data/provider/user_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides list of bikes owned by the user
final ownedBikesProvider = StateNotifierProvider<OwnedBikesNotifier, List<BikeModel>>((ref) {
  final dbAccess = ref.watch(databaseProvider);
  final locAccess = ref.watch(userLocationProvider);
  final activeUser = ref.watch(activeUserProvider);
  return OwnedBikesNotifier(dbAccess, locAccess, activeUser);
});

// The owned bikes are handled by this class
class OwnedBikesNotifier extends StateNotifier<List<BikeModel>> {
  final BKDB dbAccess;
  final UserLocation locAccess;
  final UserModel? activeUser;
  OwnedBikesNotifier(this.dbAccess, this.locAccess, this.activeUser) : super([]);

  void refresh() {
    // Update the local list of owned bikes from the database
    if(activeUser == null) {
      state = [];
    } else {
      dbAccess.getBikesOwnedByUser(activeUser!)
      .then((bikes) {
        state = bikes;
      })
      .catchError((error) {
        // TODO - send database error notification to error notifier?
        state = [];
      });
    }
  }

  void addBike({
    required String name,
    required BikeType type,
    required String description,
    required String code,
    required String imageLocalPath
  }) {
    // Note: this function should never be called before there is an active user
    locAccess.getCurrent()
    .then((point) {
      dbAccess.addBike(BikeModel.newBike(
        owner: activeUser!.docRef!,
        name: name,
        type: type,
        description: description,
        code: code,
        imageLocalPath: imageLocalPath,
        startingPoint: point))
      .then((bike) {
        state = [bike, ...state];
      })
      .catchError((error) {
        // TODO - send database error notification to error notifier?
      });
    })
    .catchError((error) {
      // TODO - send user location error notification to error notifier?
    });
  }

  void updateBikeDetails(
    BikeModel bike,
    {
    String? newName,
    BikeType? newType,
    String? newDescription,
    String? newCode,
    String? newImageLocalPath
    }) {
    // TODO - implement
  }

  void removeBike(BikeModel bike) {
    // Delete existing bike
    // TODO - make sure the bike isn't being ridden or has unresolved issue
    // TODO - handle equality operation better (with implementation of == in model class)
    dbAccess.deleteBike(bike)
    .then((_) {
      state = [...state.where((b) {return b != bike;})];
    })
    .catchError((error) {
      // TODO - send database error notification to error notifier?
    });
  }
}
