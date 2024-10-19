import 'package:cloud_firestore/cloud_firestore.dart';

enum IssueTag { 
  stolen, broken, lockBroken, lockMissing
}

// Issue data, format version 1
class IssueModel {
  final DocumentReference reporter;
  final DocumentReference bike;
  final List<IssueTag> tags;
  final String comment;
  final DateTime submitted;
  final DateTime? resolved;

  const IssueModel({
    required this.reporter,
    required this.bike,
    required this.tags,
    required this.comment,
    required this.submitted,
    required this.resolved
  });

  bool isResolved() {
    return (resolved != null);
  }
}
