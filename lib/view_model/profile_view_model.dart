import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';

class ProfileViewModel {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('Uploading !!!'),
      message: const Text('Please wait'),
    );
    File? imageFile;
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    imageFile = tempImage;

    progressDialog.show();
    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;

      String profileImageUrl = await snapshot.ref.getDownloadURL();
      await FirebaseDatabase.instance
          .ref('students/${FirebaseAuth.instance.currentUser!.uid}')
          .update({'imageUrl': profileImageUrl});

      progressDialog.dismiss();
    } catch (e) {
      progressDialog.dismiss();
    }
  }
}
