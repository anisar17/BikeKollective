import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/issue.dart';
import 'package:bike_kollective/data/model/ride.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Note: all accesses to database interface should be made through this provider
// so that we can hide the implementation details and allow for test mocks
final databaseProvider = Provider<BKDB>((ref) {
  return DebugData(); // Uncomment to work with debug data instead of real backend
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
  @override
  Future<BikeModel> addBike(BikeModel bike) {
    // TODO: implement addBike
    throw UnimplementedError();
  }

  @override
  Future<IssueModel> addIssue(IssueModel issue) {
    // TODO: implement addIssue
    throw UnimplementedError();
  }

  @override
  Future<RideModel> addRide(RideModel ride) {
    // TODO: implement addRide
    throw UnimplementedError();
  }

  @override
  Future<UserModel> addUser(UserModel user) {
    // TODO: implement addUser
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBike(BikeModel bike) {
    // TODO: implement deleteBike
    throw UnimplementedError();
  }

  @override
  Future<void> deleteIssue(IssueModel issue) {
    // TODO: implement deleteIssue
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRide(RideModel ride) {
    // TODO: implement deleteRide
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser(UserModel user) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<RideModel?> getActiveRideForUser(UserModel user) {
    // TODO: implement getActiveRideForUser
    throw UnimplementedError();
  }

  @override
  Future<List<BikeModel>> getAvailableBikesNearPoint(GeoPoint point) {
    // TODO: implement getAvailableBikesNearPoint
    throw UnimplementedError();
  }

  @override
  Future<BikeModel> getBikeByReference(DocumentReference<Object?> ref) {
    // TODO: implement getBikeByReference
    throw UnimplementedError();
  }

  @override
  Future<List<BikeModel>> getBikesOwnedByUser(UserModel user) {
    // TODO: implement getBikesOwnedByUser
    throw UnimplementedError();
  }

  @override
  Future<IssueModel> getIssueByReference(DocumentReference<Object?> ref) {
    // TODO: implement getIssueByReference
    throw UnimplementedError();
  }

  @override
  Future<RideModel> getRideByReference(DocumentReference<Object?> ref) {
    // TODO: implement getRideByReference
    throw UnimplementedError();
  }

  @override
  Future<List<RideModel>> getRidesTakenByUser(UserModel user) {
    // TODO: implement getRidesTakenByUser
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserByReference(DocumentReference<Object?> ref) {
    // TODO: implement getUserByReference
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserByUid(String uid) {
    // TODO: implement getUserByUid
    throw UnimplementedError();
  }

  @override
  Future<BikeModel> updateBike(BikeModel bike) {
    // TODO: implement updateBike
    throw UnimplementedError();
  }

  @override
  Future<IssueModel> updateIssue(IssueModel issue) {
    // TODO: implement updateIssue
    throw UnimplementedError();
  }

  @override
  Future<RideModel> updateRide(RideModel ride) {
    // TODO: implement updateRide
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateUser(UserModel user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
  // TODO - implement
}

// TODO - define Mocks for automated testing? Perhaps later

// This database implementation interacts with the Firestore backend
class RealFirestore extends BKDB {
  @override
  Future<BikeModel> addBike(BikeModel bike) {
    // TODO: implement addBike
    throw UnimplementedError();
  }

  @override
  Future<IssueModel> addIssue(IssueModel issue) {
    // TODO: implement addIssue
    throw UnimplementedError();
  }

  @override
  Future<RideModel> addRide(RideModel ride) {
    // TODO: implement addRide
    throw UnimplementedError();
  }

  @override
  Future<UserModel> addUser(UserModel user) {
    // TODO: implement addUser
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBike(BikeModel bike) {
    // TODO: implement deleteBike
    throw UnimplementedError();
  }

  @override
  Future<void> deleteIssue(IssueModel issue) {
    // TODO: implement deleteIssue
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRide(RideModel ride) {
    // TODO: implement deleteRide
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser(UserModel user) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<RideModel?> getActiveRideForUser(UserModel user) {
    // TODO: implement getActiveRideForUser
    throw UnimplementedError();
  }

  @override
  Future<List<BikeModel>> getAvailableBikesNearPoint(GeoPoint point) {
    // TODO: implement getAvailableBikesNearPoint
    throw UnimplementedError();
  }

  @override
  Future<BikeModel> getBikeByReference(DocumentReference<Object?> ref) {
    // TODO: implement getBikeByReference
    throw UnimplementedError();
  }

  @override
  Future<List<BikeModel>> getBikesOwnedByUser(UserModel user) {
    // TODO: implement getBikesOwnedByUser
    throw UnimplementedError();
  }

  @override
  Future<IssueModel> getIssueByReference(DocumentReference<Object?> ref) {
    // TODO: implement getIssueByReference
    throw UnimplementedError();
  }

  @override
  Future<RideModel> getRideByReference(DocumentReference<Object?> ref) {
    // TODO: implement getRideByReference
    throw UnimplementedError();
  }

  @override
  Future<List<RideModel>> getRidesTakenByUser(UserModel user) {
    // TODO: implement getRidesTakenByUser
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserByReference(DocumentReference<Object?> ref) {
    // TODO: implement getUserByReference
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserByUid(String uid) {
    // TODO: implement getUserByUid
    throw UnimplementedError();
  }

  @override
  Future<BikeModel> updateBike(BikeModel bike) {
    // TODO: implement updateBike
    throw UnimplementedError();
  }

  @override
  Future<IssueModel> updateIssue(IssueModel issue) {
    // TODO: implement updateIssue
    throw UnimplementedError();
  }

  @override
  Future<RideModel> updateRide(RideModel ride) {
    // TODO: implement updateRide
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateUser(UserModel user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
  // TODO - implement
}
