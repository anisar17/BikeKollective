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
  Future<DocumentReference> addUser(UserModel user);
  Future<UserModel> getUserByUid(String uid);
  Future<UserModel> getUserByReference(DocumentReference ref);
  // TODO - add more User CRUD operations

  Future<DocumentReference> addBike(BikeModel bike);
  Future<BikeModel> getBikeByReference(DocumentReference ref);
  // TODO - add more Bike CRUD operations

  Future<DocumentReference> addRide(RideModel ride);
  Future<RideModel> getRideByReference(DocumentReference ref);
  // TODO - add more Ride CRUD operations

  Future<DocumentReference> addIssue(IssueModel issue);
  Future<IssueModel> getIssueByReference(DocumentReference ref);
  // TODO - add more Issue CRUD operations
}

// This database implementation can be used by developers to create fake data
// to display while developing the UI
// Note: be sure to return DebugData in the databaseProvider above
class DebugData extends BKDB {
  // TODO - fill in with useful debug data and handling for modifying it
}

// TODO - define Mocks for automated testing? Perhaps later

// This database implementation interacts with the Firestore backend
class RealFirestore extends BKDB {
  // TODO - fill in with queries to FirebaseFirestore.instance
}
