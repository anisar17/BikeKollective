
import 'package:bike_kollective/data/model/bk_document_reference.dart';

// User data, format version 1
class UserModel {
  final BKDocumentReference? docRef;
  final String uid;
  final DateTime? verified;
  final DateTime? agreed;
  final DateTime? banned;
  final int points;
  final List<BKDocumentReference> owns;
  final List<BKDocumentReference> rides;

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

  factory UserModel.fromMap(Map<String, dynamic> map, {required BKDocumentReference? docRef}) {
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

  UserModel copyWith({
    BKDocumentReference? docRef,
    String? uid,
    DateTime? verified,
    DateTime? agreed,
    DateTime? banned,
    int? points,
    List<BKDocumentReference>? owns,
    List<BKDocumentReference>? rides
  }) {
    // Make a copy with data changes
    // Note: this function only allows setting verified/agreed/banned
    // to a non-null value since that is only what is needed at this time.
    return UserModel(
      docRef: docRef ?? this.docRef,
      uid: uid ?? this.uid,
      verified: verified ?? this.verified,
      agreed: agreed ?? this.agreed,
      banned: banned ?? this.banned,
      points: points ?? this.points,
      owns: owns ?? this.owns,
      rides: rides ?? this.rides
    );
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
