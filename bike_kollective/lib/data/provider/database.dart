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
  return DummyData(); // Uncomment to work with dummy data instead of real backend
  return RealFirestore();
});

// Interface for Bike Kollective database (implementations are below)
abstract class BKDB {
  // User CRUD operations
  Future<UserModel> addUser(UserModel user);
  Future<UserModel> getUserByReference(BKDocumentReference ref);
  Future<UserModel> getUserByUid(String uid);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(UserModel user);

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
  Future<void> deleteRide(RideModel ride);

  // Issue CRUD operations
  Future<IssueModel> addIssue(IssueModel issue);
  Future<IssueModel> getIssueByReference(BKDocumentReference ref);
  Future<IssueModel> updateIssue(IssueModel issue);
  Future<void> deleteIssue(IssueModel issue);
}



// This database implementation can be used by developers while developing the UI
// Note: be sure to return DummyData in the databaseProvider above
// Note: the dummy data is located in dummy_data.dart
class DummyData extends BKDB {
  // These maps are loaded with dummy data with BKDocumentReference.fakeDocumentId keys
  Map<String, UserModel> users;
  Map<String, BikeModel> bikes;
  Map<String, RideModel> rides;
  Map<String, IssueModel> issues;
  // The next number to use for a new BKDocumentReference.fakeDocumentId
  int nextId;

  DummyData() :  
    users = {}, bikes = {}, rides = {}, issues = {}, nextId = 0 {
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
    var ref = BKDocumentReference.fake(getTypeLetter(data) + (nextId++).toString());
    var id = ref.fakeDocumentId!;
    // Store the data based on its type
    if(T == UserModel) {
      users[id] = (data as UserModel).copyWith(docRef: ref);
    } else if(T == BikeModel) {
      bikes[id] = (data as BikeModel).copyWith(docRef: ref);
    } else if(T == RideModel) {
      rides[id] = (data as RideModel).copyWith(docRef: ref);
    } else if(T == IssueModel) {
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
    var fakeUserRef = add(UserModel(
      docRef: null,
      uid: "FAKE_UID",
      verified: DateTime.now(),
      agreed: DateTime.now(),
      banned: null,
      points: 10,
      owns: [],
      rides: []));
    // TODO - load fake users from dummy_data.dart

    // Fake bikes
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Trek Road Bike",
      type: BikeType.road,
      description: "Good road bike for cruising around town.",
      code: "1234",
      imageUrl:
          "https://c02.purpledshub.com/uploads/sites/39/2023/05/Trek-Emonda-AL5-02-2406262.jpg?w=1240&webp=1",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Specialized Mountain Bike",
      type: BikeType.mountain,
      description:
          "Great mountain bike for shredding trails and tearing up jumps.",
      code: "1234",
      imageUrl:
          "https://bikepacking.com/wp-content/uploads/2020/05/2021-specialized-rockhopper-2-2000x1333.jpg",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6027, 122.3128),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Chill Beach Cruiser",
      type: BikeType.road,
      description:
          "Beach cruiser for a leisurely ride. Great for cruising around town.",
      code: "1234",
      imageUrl:
          "https://www.beachbikes.net/cdn/shop/products/f_urban_m_7_black_1024x1024.jpg?v=1482298636",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Tandem Mountain Bike",
      type: BikeType.tandem,
      description:
          "Awesome tandem mountain bike for hitting the trails with a friend or just cruising around town.",
      code: "1234",
      imageUrl:
          "https://images.squarespace-cdn.com/content/v1/569e5cb8bfe8737de92ed0d2/1652375207957-Q54Q0YUK7TY7N8CVBEAQ/TrekT900Tandem_preview.jpg?format=750w",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Trek Road Bike",
      type: BikeType.road,
      description: "Good road bike for cruising around town.",
      code: "1234",
      imageUrl:
          "https://c02.purpledshub.com/uploads/sites/39/2023/05/Trek-Emonda-AL5-02-2406262.jpg?w=1240&webp=1",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Specialized Mountain Bike",
      type: BikeType.mountain,
      description:
          "Great mountain bike for shredding trails and tearing up jumps.",
      code: "1234",
      imageUrl:
          "https://bikepacking.com/wp-content/uploads/2020/05/2021-specialized-rockhopper-2-2000x1333.jpg",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6027, 122.3128),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Chill Beach Cruiser",
      type: BikeType.road,
      description:
          "Beach cruiser for a leisurely ride. Great for cruising around town.",
      code: "1234",
      imageUrl:
          "https://www.beachbikes.net/cdn/shop/products/f_urban_m_7_black_1024x1024.jpg?v=1482298636",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Tandem Mountain Bike",
      type: BikeType.tandem,
      description:
          "Awesome tandem mountain bike for hitting the trails with a friend or just cruising around town.",
      code: "1234",
      imageUrl:
          "https://images.squarespace-cdn.com/content/v1/569e5cb8bfe8737de92ed0d2/1652375207957-Q54Q0YUK7TY7N8CVBEAQ/TrekT900Tandem_preview.jpg?format=750w",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Trek Road Bike",
      type: BikeType.road,
      description: "Good road bike for cruising around town.",
      code: "1234",
      imageUrl:
          "https://c02.purpledshub.com/uploads/sites/39/2023/05/Trek-Emonda-AL5-02-2406262.jpg?w=1240&webp=1",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Specialized Mountain Bike",
      type: BikeType.mountain,
      description:
          "Great mountain bike for shredding trails and tearing up jumps.",
      code: "1234",
      imageUrl:
          "https://bikepacking.com/wp-content/uploads/2020/05/2021-specialized-rockhopper-2-2000x1333.jpg",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6027, 122.3128),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Chill Beach Cruiser",
      type: BikeType.road,
      description:
          "Beach cruiser for a leisurely ride. Great for cruising around town.",
      code: "1234",
      imageUrl:
          "https://www.beachbikes.net/cdn/shop/products/f_urban_m_7_black_1024x1024.jpg?v=1482298636",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Tandem Mountain Bike",
      type: BikeType.tandem,
      description:
          "Awesome tandem mountain bike for hitting the trails with a friend or just cruising around town.",
      code: "1234",
      imageUrl:
          "https://images.squarespace-cdn.com/content/v1/569e5cb8bfe8737de92ed0d2/1652375207957-Q54Q0YUK7TY7N8CVBEAQ/TrekT900Tandem_preview.jpg?format=750w",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Trek Road Bike",
      type: BikeType.road,
      description: "Good road bike for cruising around town.",
      code: "1234",
      imageUrl:
          "https://c02.purpledshub.com/uploads/sites/39/2023/05/Trek-Emonda-AL5-02-2406262.jpg?w=1240&webp=1",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Specialized Mountain Bike",
      type: BikeType.mountain,
      description:
          "Great mountain bike for shredding trails and tearing up jumps.",
      code: "1234",
      imageUrl:
          "https://bikepacking.com/wp-content/uploads/2020/05/2021-specialized-rockhopper-2-2000x1333.jpg",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6027, 122.3128),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Chill Beach Cruiser",
      type: BikeType.road,
      description:
          "Beach cruiser for a leisurely ride. Great for cruising around town.",
      code: "1234",
      imageUrl:
          "https://www.beachbikes.net/cdn/shop/products/f_urban_m_7_black_1024x1024.jpg?v=1482298636",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Tandem Mountain Bike",
      type: BikeType.tandem,
      description:
          "Awesome tandem mountain bike for hitting the trails with a friend or just cruising around town.",
      code: "1234",
      imageUrl:
          "https://images.squarespace-cdn.com/content/v1/569e5cb8bfe8737de92ed0d2/1652375207957-Q54Q0YUK7TY7N8CVBEAQ/TrekT900Tandem_preview.jpg?format=750w",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Trek Road Bike",
      type: BikeType.road,
      description: "Good road bike for cruising around town.",
      code: "1234",
      imageUrl:
          "https://c02.purpledshub.com/uploads/sites/39/2023/05/Trek-Emonda-AL5-02-2406262.jpg?w=1240&webp=1",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Specialized Mountain Bike",
      type: BikeType.mountain,
      description:
          "Great mountain bike for shredding trails and tearing up jumps.",
      code: "1234",
      imageUrl:
          "https://bikepacking.com/wp-content/uploads/2020/05/2021-specialized-rockhopper-2-2000x1333.jpg",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6027, 122.3128),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Chill Beach Cruiser",
      type: BikeType.road,
      description:
          "Beach cruiser for a leisurely ride. Great for cruising around town.",
      code: "1234",
      imageUrl:
          "https://www.beachbikes.net/cdn/shop/products/f_urban_m_7_black_1024x1024.jpg?v=1482298636",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));
    add(BikeModel(
      docRef: null,
      owner: fakeUserRef,
      name: "Tandem Mountain Bike",
      type: BikeType.tandem,
      description:
          "Awesome tandem mountain bike for hitting the trails with a friend or just cruising around town.",
      code: "1234",
      imageUrl:
          "https://images.squarespace-cdn.com/content/v1/569e5cb8bfe8737de92ed0d2/1652375207957-Q54Q0YUK7TY7N8CVBEAQ/TrekT900Tandem_preview.jpg?format=750w",
      status: BikeStatus.available,
      locationPoint: const BKGeoPoint(47.6061, 122.3328),
      locationUpdated: DateTime.now(),
      rides: [],
      issues: [],
    ));

    // Fake rides
    // TODO - add more fake rides

    // Fake issues
    // TODO - add more fake issues

    // Update the references between documents
    // Populate "owns" in UserModels
    for(var bike in bikes.values) {
      var ownerId = bike.owner.fakeDocumentId!;
      users[ownerId] = users[ownerId]!.copyWith(owns: [...(users[ownerId]!.owns), bike.docRef!]);
    }
    // TODO - update any other relationships
  }

  // User CRUD operations

  @override
  Future<UserModel> addUser(UserModel user) {
    var ref = add(user);
    return getUserByReference(ref);
  }

  @override
  Future<UserModel> getUserByReference(BKDocumentReference ref) {
    return Future<UserModel>.sync(() {return users[ref.fakeDocumentId!]!;});
  }

  @override
  Future<UserModel> getUserByUid(String uid) {
    for(var user in users.values) {
      if(user.uid == uid) {
        return Future<UserModel>.value(user);
      }
    }
    return Future<UserModel>.error(Exception("User not found"));
  }

  @override
  Future<UserModel> updateUser(UserModel user) {
    var id = user.docRef!.fakeDocumentId!;
    return Future<UserModel>.sync(() {return users.update(id, (old) {return user;});});
  }

  @override
  Future<void> deleteUser(UserModel user) {
    var id = user.docRef!.fakeDocumentId!;
    users.remove(id);
    return Future<void>.value();
  }


  // Bike CRUD operations

  @override
  Future<BikeModel> addBike(BikeModel bike) {
    var ref = add(bike);
    return getBikeByReference(ref);
  }

  @override
  Future<BikeModel> getBikeByReference(BKDocumentReference ref) {
    return Future<BikeModel>.sync(() {return bikes[ref.fakeDocumentId!]!;});
  }

  @override
  Future<List<BikeModel>> getAvailableBikesNearPoint(BKGeoPoint point) {
    const nearbyDegrees = 0.1; // About 7 miles
    return Future<List<BikeModel>>.sync(() {
      List<BikeModel> nearbyBikes = [];
      for(var bike in bikes.values) {
        if(bike.status == BikeStatus.available) {
          if(((bike.locationPoint.latitude - point.latitude).abs() < nearbyDegrees) &&
             ((bike.locationPoint.longitude - point.longitude).abs() < nearbyDegrees)) {
            nearbyBikes.add(bike);
          }
        }
      }
      return nearbyBikes;
    });
  }

  @override
  Future<List<BikeModel>> getBikesOwnedByUser(UserModel user) {
    return Future<List<BikeModel>>.sync(() {
      List<BikeModel> ownedBikes = [];
      for(var ref in user.owns) {
        ownedBikes.add(bikes[ref.fakeDocumentId!]!);
      }
      return ownedBikes;
    });
  }

  @override
  Future<BikeModel> updateBike(BikeModel bike) {
    var id = bike.docRef!.fakeDocumentId!;
    return Future<BikeModel>.sync(() {return bikes.update(id, (old) {return bike;});});
  }

  @override
  Future<void> deleteBike(BikeModel bike) {
    var id = bike.docRef!.fakeDocumentId!;
    bikes.remove(id);
    return Future<void>.value();
  }


  // Ride CRUD operations

  @override
  Future<RideModel> addRide(RideModel ride) {
    var ref = add(ride);
    return getRideByReference(ref);
  }

  @override
  Future<RideModel> getRideByReference(BKDocumentReference ref) {
    return Future<RideModel>.sync(() {return rides[ref.fakeDocumentId!]!;});
  }

  @override
  Future<RideModel?> getActiveRideForUser(UserModel user) {
    // Note: this function assumes only one active ride
    return Future<RideModel?>.sync(() {
      RideModel? activeRide;
      for(var ref in user.rides) {
        var ride = rides[ref.fakeDocumentId!]!;
        if(!ride.isFinished()) {
          activeRide = ride;
          break;
        }
      }
      return activeRide;
    });
  }

  @override
  Future<List<RideModel>> getRidesTakenByUser(UserModel user) {
    return Future<List<RideModel>>.sync(() {
      List<RideModel> ridesTaken = [];
      for(var ref in user.rides) {
        ridesTaken.add(rides[ref.fakeDocumentId!]!);
      }
      return ridesTaken;
    });
  }

  @override
  Future<RideModel> updateRide(RideModel ride) {
    var id = ride.docRef!.fakeDocumentId!;
    return Future<RideModel>.sync(() {return rides.update(id, (old) {return ride;});});
  }

  @override
  Future<void> deleteRide(RideModel ride) {
    var id = ride.docRef!.fakeDocumentId!;
    rides.remove(id);
    return Future<void>.value();
  }


  // Issue CRUD operations

  @override
  Future<IssueModel> addIssue(IssueModel issue) {
    var ref = add(issue);
    return getIssueByReference(ref);
  }

  @override
  Future<IssueModel> getIssueByReference(BKDocumentReference ref) {
    return Future<IssueModel>.sync(() {return issues[ref.fakeDocumentId!]!;});
  }

  @override
  Future<IssueModel> updateIssue(IssueModel issue) {
    var id = issue.docRef!.fakeDocumentId!;
    return Future<IssueModel>.sync(() {return issues.update(id, (old) {return issue;});});
  }

  @override
  Future<void> deleteIssue(IssueModel issue) {
    var id = issue.docRef!.fakeDocumentId!;
    issues.remove(id);
    return Future<void>.value();
  }
}



// TODO - define Mocks for automated testing? Perhaps later



// This database implementation interacts with the Firestore backend
class RealFirestore extends BKDB {
  // User CRUD operations

  @override
  Future<UserModel> addUser(UserModel user) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserByReference(BKDocumentReference ref) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserByUid(String uid) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateUser(UserModel user) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser(UserModel user) {
    // TODO: implement
    throw UnimplementedError();
  }


  // Bike CRUD operations

  @override
  Future<BikeModel> addBike(BikeModel bike) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<BikeModel> getBikeByReference(BKDocumentReference ref) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<List<BikeModel>> getAvailableBikesNearPoint(BKGeoPoint point) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<List<BikeModel>> getBikesOwnedByUser(UserModel user) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<BikeModel> updateBike(BikeModel bike) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBike(BikeModel bike) {
    // TODO: implement
    throw UnimplementedError();
  }


  // Ride CRUD operations

  @override
  Future<RideModel> addRide(RideModel ride) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<RideModel> getRideByReference(BKDocumentReference ref) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<RideModel?> getActiveRideForUser(UserModel user) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<List<RideModel>> getRidesTakenByUser(UserModel user) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<RideModel> updateRide(RideModel ride) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRide(RideModel ride) {
    // TODO: implement
    throw UnimplementedError();
  }


  // Issue CRUD operations

  @override
  Future<IssueModel> addIssue(IssueModel issue) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<IssueModel> getIssueByReference(BKDocumentReference ref) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<IssueModel> updateIssue(IssueModel issue) {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> deleteIssue(IssueModel issue) {
    // TODO: implement
    throw UnimplementedError();
  }
}
