import 'package:cloud_firestore/cloud_firestore.dart';

// Wrapper for document reference
// Note: only the database implementations should know the contents of this
// class, everyone else should treat this as an opaque type.
class BKDocumentReference {
  final DocumentReference? firestoreDocumentReference;
  final String? fakeDocumentId;

  const BKDocumentReference({
    this.firestoreDocumentReference,
    this.fakeDocumentId,
  });

  factory BKDocumentReference.firestore(DocumentReference ref) {
    // Start the user as needing verification and agreement
    return BKDocumentReference(firestoreDocumentReference: ref);
  }

  factory BKDocumentReference.fake(String id) {
    // Start the user as needing verification and agreement
    return BKDocumentReference(fakeDocumentId: id);
  }

  bool isFirestore() {
    return (firestoreDocumentReference != null);
  }

  bool isFake() {
    return (fakeDocumentId != null);
  }
}
