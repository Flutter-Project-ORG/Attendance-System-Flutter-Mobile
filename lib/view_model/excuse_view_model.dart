import 'dart:io';

import 'package:attendance_system_flutter_mobile/res/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ExcuseViewModel with ChangeNotifier {
  File? image;

  Future<void> pickImage(BuildContext context) async {
    ImageSource? imageSource;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    imageSource = ImageSource.camera;
                    Navigator.pop(context);
                  },
                  child: const Text('Camera'),
                ),
                OutlinedButton(
                  onPressed: () {
                    imageSource = ImageSource.gallery;
                    Navigator.pop(context);
                  },
                  child: const Text('Gallery'),
                ),
              ],
            ),
          );
        });
    if (imageSource == null) return;
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: imageSource!);
    if (imageFile == null) return;
    image = File(imageFile.path);
    notifyListeners();
  }

  Future<void> sendAnExcuse(BuildContext context, String insId, String subId,
      String excuseText) async {
    if (excuseText.isEmpty) {
      Components.showErrorSnackBar(context, text: 'Please add some text.');
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    showDialog(context: context, builder: (context){
      return const Center(child: CircularProgressIndicator());
    });
    try {
      String? imageUrl;
      if(image != null){
        final Reference storageRef = FirebaseStorage.instance.ref();
        final UploadTask uploadTask = storageRef.child('excuses').putFile(image!);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }
      String studentId = FirebaseAuth.instance.currentUser!.uid;
      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref('excuses/$insId/$subId/$studentId');
      /// To get student image
      final DatabaseReference imageRef =
      FirebaseDatabase.instance.ref('students/${FirebaseAuth.instance.currentUser!.uid}');
      final imageRes = await imageRef.get();
      if(!imageRes.exists) return;
      Map studentData = imageRes.value as Map;
      await dbRef.update({
        'image':studentData['imageUrl'],
        'studentName':FirebaseAuth.instance.currentUser!.displayName,
      });
      await dbRef.push().set({
        'excuseText':excuseText,
        'imageUrl':imageUrl,
      }).then((_) {
        Components.showSuccessSnackBar(context, text: 'Excuse sent.');
      });
      navigator.pop();
      navigator.pop();

    } catch (e) {
      navigator.pop();
      Components.showErrorSnackBar(context, text: 'Try again.');
    }
  }
}
