import 'dart:async';

import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/bk_document_reference.dart';
import 'package:bike_kollective/data/model/bk_geo_point.dart';
import 'package:bike_kollective/data/model/issue.dart';
import 'package:bike_kollective/data/model/ride.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Note: all accesses to database interface should be made through this provider
// so that we can hide the implementation details and allow for test mocks
final databaseProvider = Provider<BKDB>((ref) {
  //return DummyData(); // Uncomment to work with dummy data instead of real backend
  return RealFirestore();
});

// Interface for Bike Kollective database (implementations are below)
abstract class BKDB {
  // User CRUD operations
  Future<UserModel> addUser(String uid, String email) ;
  Future<UserModel> getUserByReference(BKDocumentReference ref);
  Future<UserModel?> getUserByUid(String uid);
  Future<UserModel> updateUser(UserModel user);
  Future<UserModel> setName(UserModel user, String newName);
  // deleteUser not needed yet

  // Bike CRUD operations
  Future<BikeModel> addBike(BikeModel bike);
  Future<BikeModel> getBikeByReference(BKDocumentReference ref);
  Future<List<BikeModel>> getAvailableBikesNearPoint(BKGeoPoint point);
  Future<List<BikeModel>> getBikesOwnedByUser(UserModel user);
  Future<BikeModel> updateBike(BikeModel bike);
  Future<void> deleteBike(BikeModel bike);

  // Ride CRUD operations
  Future<RideModel> addRide(RideModel ride);
  Future<RideModel> getRideByReference(BKDocumentReference ref);
  Future<RideModel?> getActiveRideForUser(UserModel user);
  Future<List<RideModel>> getRidesTakenByUser(UserModel user);
  Future<RideModel> updateRide(RideModel ride);
  // deleteRide not needed yet

  // Issue CRUD operations
  Future<IssueModel> addIssue(IssueModel issue);
  Future<IssueModel> getIssueByReference(BKDocumentReference ref);
  Future<IssueModel?> getActiveIssueForBike(BikeModel bike);
  Future<IssueModel> updateIssue(IssueModel issue);
  // deleteIssue not needed yet
}

// This database implementation can be used by developers while developing the UI
// Note: be sure to return DummyData in the databaseProvider above
class DummyData extends BKDB {
  // These maps are loaded with dummy data with BKDocumentReference.fakeDocumentId keys
  Map<String, UserModel> users;
  Map<String, BikeModel> bikes;
  Map<String, RideModel> rides;
  Map<String, IssueModel> issues;
  // The next number to use for a new BKDocumentReference.fakeDocumentId
  int nextId;

  DummyData()
      : users = {},
        bikes = {},
        rides = {},
        issues = {},
        nextId = 0 {
    init();
  }

  String getTypeLetter<T>(T data) {
    return {
      UserModel: "U",
      BikeModel: "B",
      RideModel: "R",
      IssueModel: "I"
    }[T]!;
  }

  BKDocumentReference add<T>(T data) {
    // Helper to add new data to the "database" properly, putting it
    // in the right map based on its type and giving it a valid
    // document reference. Returns the document reference for the
    // new item.
    // Generate a fake document reference with a unique ID
    var ref =
        BKDocumentReference.fake(getTypeLetter(data) + (nextId++).toString());
    var id = ref.fakeDocumentId!;
    // Store the data based on its type
    if (T == UserModel) {
      users[id] = (data as UserModel).copyWith(docRef: ref);
    } else if (T == BikeModel) {
      bikes[id] = (data as BikeModel).copyWith(docRef: ref);
    } else if (T == RideModel) {
      rides[id] = (data as RideModel).copyWith(docRef: ref);
    } else if (T == IssueModel) {
      issues[id] = (data as IssueModel).copyWith(docRef: ref);
    } else {
      assert(false, "Unknown data type");
    }
    return ref;
  }

  void init() {
    // (Re)populate the dummy data with initial values
    // Clear old data
    users.clear();
    bikes.clear();
    rides.clear();
    issues.clear();
    nextId = 0;

    // Store initial fake data

    // Fake users
    var fakeUserRef1 = add(UserModel(
      docRef: null,
      uid: "FAKE_UID1",
      email: "email1@gmail.com",
      name: "Name",
      verified: DateTime.now(),
      agreed: DateTime.now(),
      banned: null,
      points: 10));
    var fakeUserRef2 = add(UserModel(
      docRef: null,
      uid: "FAKE_UID2",
      email: "email2@gmail.com",
      name: "Name2",
      verified: DateTime.now(),
      agreed: DateTime.now(),
      banned: null,
      points: 20));

    // Fake bikes
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef1,
      name: "Trek Road Bike",
      type: BikeType.road,
      description: "Good road bike for cruising around town.",
      code: "1234",
      imageUrl:
          "https://c02.purpledshub.com/uploads/sites/39/2023/05/Trek-Emonda-AL5-02-2406262.jpg?w=1240&webp=1",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(44.5646, -123.2620),
      locationUpdated: DateTime.now(),
      totalStars: 0,
      totalReviews: 0
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef1,
      name: "Specialized Mountain Bike",
      type: BikeType.mountain,
      description:
          "Great mountain bike for shredding trails and tearing up jumps.",
      code: "1234",
      imageUrl:
          "https://bikepacking.com/wp-content/uploads/2020/05/2021-specialized-rockhopper-2-2000x1333.jpg",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(44.5671, -123.2630),
      locationUpdated: DateTime.now(),
      totalStars: 5,
      totalReviews: 1
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef1,
      name: "Chill Beach Cruiser",
      type: BikeType.road,
      description:
          "Beach cruiser for a leisurely ride. Great for cruising around town.",
      code: "1234",
      imageUrl:
          "https://www.beachbikes.net/cdn/shop/products/f_urban_m_7_black_1024x1024.jpg?v=1482298636",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(44.5649, -123.2782),
      locationUpdated: DateTime.now(),
      totalStars: 7,
      totalReviews: 2
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef2,
      name: "Tandem Mountain Bike",
      type: BikeType.tandem,
      description:
          "Awesome tandem mountain bike for hitting the trails with a friend or just cruising around town.",
      code: "1234",
      imageUrl:
          "https://images.squarespace-cdn.com/content/v1/569e5cb8bfe8737de92ed0d2/1652375207957-Q54Q0YUK7TY7N8CVBEAQ/TrekT900Tandem_preview.jpg?format=750w",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6086, -122.3098),
      locationUpdated: DateTime.now(),
      totalStars: 12,
      totalReviews: 3
    ));

    // Fake rides
    // TODO - add more fake rides

    // Fake issues
    // TODO - add more fake issues
  }

  // User CRUD operations

  @override
  Future<UserModel> addUser(String uid, String email) async {
    var ref = add(UserModel.newUser(uid: uid, email: email));
    return getUserByReference(ref);
  }

  @override
  Future<UserModel> addUserEmail(String email, String password) async {
    var ref = add(UserModel.newUser(email: email));
    return getUserByReference(ref);
  }

  @override
  Future<UserModel> getUserByReference(BKDocumentReference ref) async {
    return users[ref.fakeDocumentId!]!;
  }

  @override
  Future<UserModel?> getUserByUid(String uid) async {
    for (var user in users.values) {
      if (user.uid == uid) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    var id = user.docRef!.fakeDocumentId!;
    return users.update(id, (old) {return user;});
  }

  @override
  Future<UserModel> setName(UserModel user, String newName) async {
    var id = user.docRef!.fakeDocumentId!;
    var updatedUser = user.copyWith(name: newName);
    users[id] = updatedUser;
    return updatedUser;
  }

  // Bike CRUD operations

  @override
  Future<BikeModel> addBike(BikeModel bike) async {
    var ref = add(bike);
    return getBikeByReference(ref);
  }

  @override
  Future<BikeModel> getBikeByReference(BKDocumentReference ref) async {
    return bikes[ref.fakeDocumentId!]!;
  }

  @override
  Future<List<BikeModel>> getAvailableBikesNearPoint(BKGeoPoint point) async {
    const nearbyDegrees = 0.1; // About 7 miles
    List<BikeModel> nearbyBikes = [];
    for (var bike in bikes.values) {
      if (bike.status == BikeStatus.available) {
        if (((bike.locationPoint.latitude - point.latitude).abs() <
                nearbyDegrees) &&
            ((bike.locationPoint.longitude - point.longitude).abs() <
                nearbyDegrees)) {
          nearbyBikes.add(bike);
        }
      }
    }
    return nearbyBikes;
  }

  @override
  Future<List<BikeModel>> getBikesOwnedByUser(UserModel user) async {
    List<BikeModel> ownedBikes = [];
    for (var bike in bikes.values) {
      if(bike.owner == user.docRef) {
        ownedBikes.add(bike);
      }
    }
    return ownedBikes;
  }

  @override
  Future<BikeModel> updateBike(BikeModel bike) async {
    var id = bike.docRef!.fakeDocumentId!;
    return bikes.update(id, (_) {return bike;});
  }

  @override
  Future<void> deleteBike(BikeModel bike) async {
    var id = bike.docRef!.fakeDocumentId!;
    bikes.remove(id);
  }

  // Ride CRUD operations

  @override
  Future<RideModel> addRide(RideModel ride) async {
    var ref = add(ride);
    return getRideByReference(ref);
  }

  @override
  Future<RideModel> getRideByReference(BKDocumentReference ref) async {
    return rides[ref.fakeDocumentId!]!;
  }

  @override
  Future<RideModel?> getActiveRideForUser(UserModel user) async {
    // Note: this function assumes only one active ride
    RideModel? activeRide;
    for (var ride in rides.values) {
      if(ride.rider == user.docRef && !ride.isFinished()) {
        activeRide = ride;
        break;
      }
    }
    return activeRide;
  }

  @override
  Future<List<RideModel>> getRidesTakenByUser(UserModel user) async {
    List<RideModel> ridesTaken = [];
    for (var ride in rides.values) {
      if(ride.rider == user.docRef) {
        ridesTaken.add(ride);
      }
    }
    return ridesTaken;
  }

  @override
  Future<RideModel> updateRide(RideModel ride) async {
    var id = ride.docRef!.fakeDocumentId!;
    return rides.update(id, (old) {return ride;});
  }

  // Issue CRUD operations

  @override
  Future<IssueModel> addIssue(IssueModel issue) async {
    var ref = add(issue);
    return getIssueByReference(ref);
  }

  @override
  Future<IssueModel> getIssueByReference(BKDocumentReference ref) async {
    return issues[ref.fakeDocumentId!]!;
  }

  @override
  Future<IssueModel?> getActiveIssueForBike(BikeModel bike) async {
    // Note: this function assumes only one active issue
    IssueModel? activeIssue;
    for (var issue in issues.values) {
      if(issue.bike == bike.docRef && !issue.isResolved()) {
        activeIssue = issue;
        break;
      }
    }
    return activeIssue;
  }

  @override
  Future<IssueModel> updateIssue(IssueModel issue) async {
    var id = issue.docRef!.fakeDocumentId!;
    return issues.update(id, (_) {return issue;});
  }
}

// This database implementation interacts with the Firestore backend
class RealFirestore extends BKDB {

  // Helper functions

  void _applyWrappers(Map<String, dynamic> data) {
    // Wrap the Firestore types and convert as needed
    data.updateAll((_, value) {
      if(value is DocumentReference<Map<String, dynamic>>) {
        return BKDocumentReference.firestore(value);
      } else if(value is GeoPoint) {
        return BKGeoPoint.fromGeoPoint(value);
      } else if(value is GeoPoint?) {
        return value != null ? BKGeoPoint.fromGeoPoint(value) : null;
      } else if(value is Timestamp) {
        return value.toDate();
      } else {
        return value;
      }
    });
  }

  void _removeWrappers(Map<String, dynamic> data) {
    data.updateAll((_, value) {
      // Extract the Firestore types and convert as needed
      if(value is BKDocumentReference) {
        return value.firestoreDocumentReference!;
      } else if(value is BKGeoPoint) {
        return value.toGeoPoint();
      } else if(value is BKGeoPoint?) {
        return value?.toGeoPoint();
      } else {
        return value;
      }
    });
  }

  UserModel _userFromFirestore(Map<String, dynamic> data, DocumentReference<Map<String, dynamic>> ref) {
    _applyWrappers(data);
    return UserModel.fromMap(data, docRef: BKDocumentReference.firestore(ref));
  }

  BikeModel _bikeFromFirestore(Map<String, dynamic> data, DocumentReference<Map<String, dynamic>> ref) {
    _applyWrappers(data);
    return BikeModel.fromMap(data, docRef: BKDocumentReference.firestore(ref));
  }

  RideModel _rideFromFirestore(Map<String, dynamic> data, DocumentReference<Map<String, dynamic>> ref) {
    _applyWrappers(data);
    return RideModel.fromMap(data, docRef: BKDocumentReference.firestore(ref));
  }

  IssueModel _issueFromFirestore(Map<String, dynamic> data, DocumentReference<Map<String, dynamic>> ref) {
    _applyWrappers(data);
    return IssueModel.fromMap(data, docRef: BKDocumentReference.firestore(ref));
  }

  Map<String, dynamic> _toFirestore<T>(T model) {
    // Helper to convert a model class to a Firestore data map, removing type wrappers
    var data = <String, dynamic>{};
    if (T == UserModel) {
      data = (model as UserModel).toMap();
    } else if (T == BikeModel) {
      data = (model as BikeModel).toMap();
    } else if (T == RideModel) {
      data = (model as RideModel).toMap();
    } else if (T == IssueModel) {
      data = (model as IssueModel).toMap();
    } else {
      assert(false, "Unknown data type");
    }
    _removeWrappers(data);
    return data;
  }

  // User CRUD operations

  @override
  Future<UserModel> addUser(String uid, String email) async {
    var data = _toFirestore(UserModel.newUser(uid: uid, email: email));
    var ref = await FirebaseFirestore.instance.collection("users").add(data);
    return _userFromFirestore(data, ref);
  }

  @override
  Future<UserModel> addUserEmail(String email, String password) async {
    var data = _toFirestore(UserModel.newUser(email: email));
    var ref = await FirebaseFirestore.instance.collection("users").add(data);
    return _userFromFirestore(data, ref);
  }

  @override
  Future<UserModel> getUserByReference(BKDocumentReference ref) async {
    var snapshot = await ref.firestoreDocumentReference!.get();
    var data = snapshot.data()!;
    return _userFromFirestore(data, snapshot.reference);
  }

  @override
  Future<UserModel?> getUserByUid(String uid) async {
    var snapshot = await FirebaseFirestore.instance.collection("users")
      .where("uid", isEqualTo: uid)
      .get();
    if(snapshot.size > 0) {
      return _userFromFirestore(snapshot.docs[0].data(), snapshot.docs[0].reference);
    } else {
      return null;
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    var data = _toFirestore(user);
    await user.docRef!.firestoreDocumentReference!.set(data);
    return user;
  }

  @override 
  Future<UserModel> setName(UserModel user, String newName) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'name': newName});
    return user.copyWith(name: newName);
  }

  // Bike CRUD operations

  @override
  Future<BikeModel> addBike(BikeModel bike) async {
    var data = _toFirestore(bike);
    var ref = await FirebaseFirestore.instance.collection("bikes").add(data);
    return _bikeFromFirestore(data, ref);
  }

  @override
  Future<BikeModel> getBikeByReference(BKDocumentReference ref) async {
    var snapshot = await ref.firestoreDocumentReference!.get();
    var data = snapshot.data()!;
    return _bikeFromFirestore(data, snapshot.reference);
  }

  @override
  Future<List<BikeModel>> getAvailableBikesNearPoint(BKGeoPoint point) async {
    const nearbyDegrees = 0.1; // About 7 miles
    var lesserPoint = GeoPoint(point.latitude - nearbyDegrees, point.longitude - nearbyDegrees);
    var greaterPoint = GeoPoint(point.latitude + nearbyDegrees, point.longitude + nearbyDegrees);
    var snapshot = await FirebaseFirestore.instance.collection("bikes")
      .where("locationPoint", isGreaterThan: lesserPoint)
      .where("locationPoint", isLessThan: greaterPoint)
      .where("status", isEqualTo: "available")
      .get();
    return snapshot.docs.map((doc) => _bikeFromFirestore(doc.data(), doc.reference)).toList();
  }

  @override
  Future<List<BikeModel>> getBikesOwnedByUser(UserModel user) async {
    var snapshot = await FirebaseFirestore.instance.collection("bikes")
      .where("owner", isEqualTo: user.docRef!.firestoreDocumentReference!)
      .orderBy("locationUpdated", descending: true)
      .get();
    return snapshot.docs.map((doc) => _bikeFromFirestore(doc.data(), doc.reference)).toList();
  }

  @override
  Future<BikeModel> updateBike(BikeModel bike) async {
    var data = _toFirestore(bike);
    await bike.docRef!.firestoreDocumentReference!.set(data);
    return bike;
  }

  @override
  Future<void> deleteBike(BikeModel bike) async {
    await bike.docRef!.firestoreDocumentReference!.delete();
  }

  // Ride CRUD operations

  @override
  Future<RideModel> addRide(RideModel ride) async {
    var data = _toFirestore(ride);
    var ref = await FirebaseFirestore.instance.collection("rides").add(data);
    return _rideFromFirestore(data, ref);
  }

  @override
  Future<RideModel> getRideByReference(BKDocumentReference ref) async {
    var snapshot = await ref.firestoreDocumentReference!.get();
    var data = snapshot.data()!;
    return _rideFromFirestore(data, snapshot.reference);
  }

  @override
  Future<RideModel?> getActiveRideForUser(UserModel user) async {
    var snapshot = await FirebaseFirestore.instance.collection("rides")
      .where("rider", isEqualTo: user.docRef!.firestoreDocumentReference!)
      .where("finishTime", isNull: true)
      .orderBy("startTime", descending: true)
      .get();
    if(snapshot.docs.isEmpty) {
      return null;
    } else {
      var doc = snapshot.docs[0];
      return _rideFromFirestore(doc.data(), doc.reference);
    }
  }

  @override
  Future<List<RideModel>> getRidesTakenByUser(UserModel user) async {
    var snapshot = await FirebaseFirestore.instance.collection("rides")
      .where("rider", isEqualTo: user.docRef!.firestoreDocumentReference!)
      .orderBy("startTime", descending: true)
      .get();
    return snapshot.docs.map((doc) => _rideFromFirestore(doc.data(), doc.reference)).toList();
  }

  @override
  Future<RideModel> updateRide(RideModel ride) async {
    var data = _toFirestore(ride);
    await ride.docRef!.firestoreDocumentReference!.set(data);
    return ride;
  }

  // Issue CRUD operations

  @override
  Future<IssueModel> addIssue(IssueModel issue) async {
    var data = _toFirestore(issue);
    var ref = await FirebaseFirestore.instance.collection("issues").add(data);
    return _issueFromFirestore(data, ref);
  }

  @override
  Future<IssueModel> getIssueByReference(BKDocumentReference ref) async {
    var snapshot = await ref.firestoreDocumentReference!.get();
    var data = snapshot.data()!;
    return _issueFromFirestore(data, snapshot.reference);
  }

  @override
  Future<IssueModel?> getActiveIssueForBike(BikeModel bike) async {
    var snapshot = await FirebaseFirestore.instance.collection("issues")
      .where("bike", isEqualTo: bike.docRef!.firestoreDocumentReference!)
      .where("resolved", isNull: true)
      .orderBy("submitted", descending: true)
      .get();
    if(snapshot.docs.isEmpty) {
      return null;
    } else {
      var doc = snapshot.docs[0];
      return _issueFromFirestore(doc.data(), doc.reference);
    }
  }

  @override
  Future<IssueModel> updateIssue(IssueModel issue) async {
    var data = _toFirestore(issue);
    await issue.docRef!.firestoreDocumentReference!.set(data);
    return issue;
  }
}
