import 'package:bike_kollective/data/model/bike.dart';
import 'package:bike_kollective/data/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum IssueTag { 
  stolen, broken, lockBroken, lockMissing
}

// Issue data, format version 1
class IssueModel {
  final DocumentReference? docRef;
  final DocumentReference reporter;
  final DocumentReference bike;
  final List<IssueTag> tags;
  final String comment;
  final DateTime submitted;
  final DateTime? resolved;

  const IssueModel({
    required this.docRef,
    required this.reporter,
    required this.bike,
    required this.tags,
    required this.comment,
    required this.submitted,
    required this.resolved
  });

  factory IssueModel.newIssue({
    required UserModel reporter,
    required BikeModel bike,
    required List<IssueTag> tags,
    required String comment
    }) {
    return IssueModel(
      docRef: null,
      reporter: reporter.docRef!,
      bike: bike.docRef!,
      tags: tags,
      comment: comment,
      submitted: DateTime.now(),
      resolved: null
    );
  }

  factory IssueModel.fromMap(Map<String, dynamic> map, {required DocumentReference? docRef}) {
    return IssueModel(
      docRef: docRef,
      reporter: map["reporter"],
      bike: map["bike"],
      tags: map["tags"],
      comment: map["comment"],
      submitted: map["submitted"],
      resolved: map["resolved"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "reporter": reporter,
      "bike": bike,
      "tags": tags,
      "comment": comment,
      "submitted": submitted,
      "resolved": resolved,
    };
  }

  bool isFromDatabase() {
    return (docRef != null);
  }

  bool isResolved() {
    return (resolved != null);
  }
}
