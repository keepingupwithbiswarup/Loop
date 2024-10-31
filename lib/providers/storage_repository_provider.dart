import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopedin/providers/firebaseproviders.dart';

final firebaseStorageProvider = Provider((ref) {
  return StorageRepository(firebaseStorage: ref.watch(storageProvider));
});

class StorageRepository {
  final FirebaseStorage _firebaseStorage;
  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;
  Future<String> storeFile(
      {required String path, required String id, required File? file}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      throw "Error occured";
    }
  }
}
