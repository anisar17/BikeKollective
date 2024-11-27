import 'package:cloud_firestore/cloud_firestore.dart';

// Wrapper for document reference
// Note: only the database implementations should know the contents of this
// class, everyone else should treat this as an opaque type.
class BKDocumentReference {
  final DocumentReference<Map<String, dynamic>>? firestoreDocumentReference;
  final String? fakeDocumentId;

  const BKDocumentReference({
    this.firestoreDocumentReference,
    this.fakeDocumentId,
  });

  factory BKDocumentReference.firestore(DocumentReference<Map<String, dynamic>> ref) {
    return BKDocumentReference(firestoreDocumentReference: ref);
  }

  factory BKDocumentReference.fake(String id) {
    return BKDocumentReference(fakeDocumentId: id);
  }

  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true;
    if(runtimeType != other.runtimeType) return false;
    if(other is BKDocumentReference) {
      if(firestoreDocumentReference != null) {
        return firestoreDocumentReference!.id == other.firestoreDocumentReference?.id;
      }
      return fakeDocumentId == other.fakeDocumentId;
    }
    return false;
  }
  
  @override
  int get hashCode => super.hashCode;

  bool isFirestore() {
    return (firestoreDocumentReference != null);
  }

  bool isFake() {
    return (fakeDocumentId != null);
  }
 Future<Map<String, dynamic>?> getData() async {
    if (isFirestore() && firestoreDocumentReference != null) {
      final snapshot = await firestoreDocumentReference!.get();
      if (snapshot.exists) {
        return snapshot.data();
      }
    } 
    return null; // or throw an error or return default data
  }

  String? getId() {
    if (isFirestore()) {
      return firestoreDocumentReference?.id;
    } 
    return fakeDocumentId; // Return the fake ID if no Firestore reference exists
  }
}
