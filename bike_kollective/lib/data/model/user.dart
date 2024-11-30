
import 'package:bike_kollective/data/model/bk_document_reference.dart';

// User data, format version 1
class UserModel {
  final BKDocumentReference? docRef;
  final String uid;
  final String? name;
  final DateTime? verified;
  final DateTime? agreed;
  final DateTime? banned;
  final int points;

  const UserModel({
    required this.docRef,
    required this.uid,
    required this.name,
    required this.verified,
    required this.agreed,
    required this.banned,
    required this.points
  });

  factory UserModel.newUser({
    required String uid
    }) {
    // Start the user as needing verification and agreement
    return UserModel(
      docRef: null,
      uid: uid,
      name: null,
      verified: null,
      agreed: null,
      banned: null,
      points: 0
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {required BKDocumentReference? docRef}) {
    return UserModel(
      docRef: docRef,
      uid: map["uid"],
      name: map["name"],
      verified: map["verified"],
      agreed: map["agreed"],
      banned: map["banned"],
      points: map["points"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "verified": verified,
      "agreed": agreed,
      "banned": banned,
      "points": points
    };
  }

  UserModel copyWith({
    BKDocumentReference? docRef,
    String? uid,
    String? name,
    DateTime? verified,
    DateTime? agreed,
    DateTime? banned,
    int? points
  }) {
    // Make a copy with data changes
    // Note: this function only allows setting verified/agreed/banned
    // to a non-null value since that is only what is needed at this time.
    return UserModel(
      docRef: docRef ?? this.docRef,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      verified: verified ?? this.verified,
      agreed: agreed ?? this.agreed,
      banned: banned ?? this.banned,
      points: points ?? this.points
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
