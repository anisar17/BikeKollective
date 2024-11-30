import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef Url = String;

final imageStorageProvider = Provider<ImageStorage>((ref) {
  return RealFirebaseStorage();
});

// Interface for image storage (implementations are below)
abstract class ImageStorage {
  Future<Url> uploadBikeImage(Uint8List image);
  Future<void> deleteBikeImage(Url url);
}

// This implementation interacts with the Firebase cloud storage
class RealFirebaseStorage extends ImageStorage {
  final bucketUrl = "gs://bike-kollective-c4659.firebasestorage.app";
  final bikeImageStoragePath = "bike_images/";
  @override
  Future<Url> uploadBikeImage(Uint8List image) async {
    // TODO: allow other file formats (PNG required)
    // TODO: replace with better solution for unique name (e.g. UUID generator)
    final uniqueFileName = "b${DateTime.now().microsecondsSinceEpoch}.png";
    final storageRef = FirebaseStorage.instanceFor(bucket: bucketUrl);
    final fileRef = storageRef.ref().child(bikeImageStoragePath + uniqueFileName);
    final uploadTask = await fileRef.putData(image, SettableMetadata(contentType: 'image/png')).timeout(const Duration(seconds: 15));
    final url = await uploadTask.ref.getDownloadURL();
    return url;
  }

  @override
  Future<void> deleteBikeImage(Url url) async {
    final storageRef = FirebaseStorage.instanceFor(bucket: bucketUrl);
    final fileRef = storageRef.ref().child(url);
    await fileRef.delete();
  }
}
