import "package:cloud_firestore/cloud_firestore.dart";

// User data, format version 1
class UserModel {
  final DocumentReference? docRef;
  final String uid;
  final DateTime? verified;
  final DateTime? agreed;
  final DateTime? banned;
  final int points;
  final List<DocumentReference> owns;
  final List<DocumentReference> rides;

  const UserModel({
    required this.docRef,
    required this.uid,
    required this.verified,
    required this.agreed,
    required this.banned,
    required this.points,
    required this.owns,
    required this.rides,
  });

  factory UserModel.newUser({
    required String uid
    }) {
    // Start the user as needing verification and agreement
    return UserModel(
      docRef: null,
      uid: uid,
      verified: null,
      agreed: null,
      banned: null,
      points: 0,
      owns: [],
      rides: [],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {required DocumentReference? docRef}) {
    return UserModel(
      docRef: docRef,
      uid: map["uid"],
      verified: map["verified"],
      agreed: map["agreed"],
      banned: map["banned"],
      points: map["points"],
      owns: map["owns"],
      rides: map["rides"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "verified": verified,
      "agreed": agreed,
      "banned": banned,
      "points": points,
      "owns": owns,
      "rides": rides,
    };
  }

  bool isFromDatabase() {
    return (docRef != null);
  }

  bool isVerified() {
    return (verified != null);
  }

  bool isAgreed() {
    return (agreed != null);
  }

  bool isBanned() {
    return (banned != null);
  }
}
