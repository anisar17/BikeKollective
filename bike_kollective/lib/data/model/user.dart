
import 'package:bike_kollective/data/model/bk_document_reference.dart';

// User data, format version 1
class UserModel {
  final BKDocumentReference? docRef;
  final String? uid;
  final String? email;
  final String? password;
  final DateTime? verified;
  final DateTime? agreed;
  final DateTime? banned;
  final int points;

  const UserModel({
    required this.docRef,
    required this.uid,
    required this.email,
    required this.password,
    required this.verified,
    required this.agreed,
    required this.banned,
    required this.points
  });

  factory UserModel.newUser({
    String? uid,
    String? email,
    String? password,
    }) {
    // Start the user as needing verification and agreement
    return UserModel(
      docRef: null,
      uid: uid,
      email: email,
      password: password,
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
      email: map["email"],
      password: map["password"],
      verified: map["verified"],
      agreed: map["agreed"],
      banned: map["banned"],
      points: map["points"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "password": password,
      "verified": verified,
      "agreed": agreed,
      "banned": banned,
      "points": points
    };
  }

  UserModel copyWith({
    BKDocumentReference? docRef,
    String? uid,
    String? email,
    String? password,
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
      email: email ?? this.email,
      password: password ?? this.password,
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
