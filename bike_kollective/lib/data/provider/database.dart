import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/issue.dart';
import 'package:bike_kollective/data/model/ride.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Note: all accesses to database interface should be made through this provider
// so that we can hide the implementation details and allow for test mocks
final databaseProvider = Provider<BKDB>((ref) {
  // return DebugData(); // Uncomment to work with debug data instead of real backend
  return RealFirestore();
});

// Interface for Bike Kollective database (implementations are below)
abstract class BKDB {
  // User CRUD operations
  Future<UserModel> addUser(UserModel user);
  Future<UserModel> getUserByReference(DocumentReference ref);
  Future<UserModel> getUserByUid(String uid);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(UserModel user);

  // Bike CRUD operations
  Future<BikeModel> addBike(BikeModel bike);
  Future<BikeModel> getBikeByReference(DocumentReference ref);
  Future<List<BikeModel>> getAvailableBikesNearPoint(GeoPoint point);
  Future<List<BikeModel>> getBikesOwnedByUser(UserModel user);
  Future<BikeModel> updateBike(BikeModel bike);
  Future<void> deleteBike(BikeModel bike);

  // Ride CRUD operations
  Future<RideModel> addRide(RideModel ride);
  Future<RideModel> getRideByReference(DocumentReference ref);
  Future<RideModel?> getActiveRideForUser(UserModel user);
  Future<List<RideModel>> getRidesTakenByUser(UserModel user);
  Future<RideModel> updateRide(RideModel ride);
  Future<void> deleteRide(RideModel ride);

  // Issue CRUD operations
  Future<IssueModel> addIssue(IssueModel issue);
  Future<IssueModel> getIssueByReference(DocumentReference ref);
  Future<IssueModel> updateIssue(IssueModel issue);
  Future<void> deleteIssue(IssueModel issue);
}

// This database implementation can be used by developers to create fake data
// to display while developing the UI
// Note: be sure to return DebugData in the databaseProvider above
class DebugData extends BKDB {
  // TODO - implement
}

// TODO - define Mocks for automated testing? Perhaps later

// This database implementation interacts with the Firestore backend
class RealFirestore extends BKDB {
  // TODO - implement
}
