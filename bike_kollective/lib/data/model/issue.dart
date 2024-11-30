import 'package:bike_kollective/data/model/bk_document_reference.dart';

enum IssueTag { 
  stolen, broken, lockBroken, lockMissing
}

final Map<IssueTag, String> tagDisplayNames = {
  IssueTag.stolen: 'Stolen',
  IssueTag.broken: 'Broken',
  IssueTag.lockBroken: 'Lock Broken',
  IssueTag.lockMissing: 'Lock Missing',
};

// Issue data, format version 1
class IssueModel {
  final BKDocumentReference? docRef;
  final BKDocumentReference reporter;
  final BKDocumentReference bike;
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
    required BKDocumentReference reporter,
    required BKDocumentReference bike,
    required List<IssueTag> tags,
    required String comment
    }) {
    return IssueModel(
      docRef: null,
      reporter: reporter,
      bike: bike,
      tags: tags,
      comment: comment,
      submitted: DateTime.now(),
      resolved: null
    );
  }

  factory IssueModel.fromMap(Map<String, dynamic> map, {required BKDocumentReference? docRef}) {
    return IssueModel(
      docRef: docRef,
      reporter: map["reporter"],
      bike: map["bike"],
      tags: map["tags"].map<IssueTag>((name) => IssueTag.values.byName(name)).toList(),
      comment: map["comment"],
      submitted: map["submitted"],
      resolved: map["resolved"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "reporter": reporter,
      "bike": bike,
      "tags": tags.map((tag) => tag.name).toList(),
      "comment": comment,
      "submitted": submitted,
      "resolved": resolved,
    };
  }

  IssueModel copyWith({
    BKDocumentReference? docRef,
    BKDocumentReference? reporter,
    BKDocumentReference? bike,
    List<IssueTag>? tags,
    String? comment,
    DateTime? submitted,
    DateTime? resolved
  }) {
    // Make a copy with data changes
    return IssueModel(
      docRef: docRef ?? this.docRef,
      reporter: reporter ?? this.reporter,
      bike: bike ?? this.bike,
      tags: tags ?? this.tags,
      comment: comment ?? this.comment,
      submitted: submitted ?? this.submitted,
      resolved: resolved ?? this.resolved
    );
  }

  bool isFromDatabase() {
    return (docRef != null);
  }

  bool isResolved() {
    return (resolved != null);
  }
}
