import 'package:cloud_firestore/cloud_firestore.dart';

// User data, format version 1
class UserModel {
  final String uid;
  final DateTime? verified;
  final DateTime? agreed;
  final DateTime? banned;
  final int points;
  final List<DocumentReference> owns;
  final List<DocumentReference> rides;

  const UserModel({
    required this.uid,
    required this.verified,
    required this.agreed,
    required this.banned,
    required this.points,
    required this.owns,
    required this.rides,
  });

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
