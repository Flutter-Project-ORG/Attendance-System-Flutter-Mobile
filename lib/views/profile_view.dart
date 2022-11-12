import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:badges/badges.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import '../view_model/profile_view_model.dart';
import 'auth_view.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);

  final ProfileViewModel _viewModel = ProfileViewModel();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Tooltip(
            message: 'Logout',
            child: IconButton(
              onPressed: () {
                _viewModel.logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const AuthView()));
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseDatabase.instance.ref('students/${user!.uid}').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Map data = snapshot.data!.value as Map;
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Center(
                  child: Badge(
                    position: BadgePosition.bottomEnd(),
                    badgeContent: Tooltip(
                      message: 'Update image',
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _viewModel.pickImageFromGallery(context);
                          // showModalBottomSheet(
                          //     context: context,
                          //     builder: (context) {
                          //       return Padding(
                          //         padding: const EdgeInsets.all(10),
                          //         child: Column(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             ListTile(
                          //               leading: const Icon(Icons.image),
                          //               title: const Text('From Gallery'),
                          //               onTap: () {
                          //                 _pickImageFromGallery();
                          //                 Navigator.of(context).pop();
                          //               },
                          //             ),
                          //             ListTile(
                          //               leading: const Icon(Icons.camera_alt),
                          //               title: const Text('From Camera'),
                          //               onTap: () {
                          //                 _pickImageFromCamera();
                          //                 Navigator.of(context).pop();
                          //               },
                          //             ),
                          //           ],
                          //         ),
                          //       );
                          //     });
                        },
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: data['imageUrl'] == null
                          ? const NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGrQoGh518HulzrSYOTee8UO517D_j6h4AYQ&usqp=CAU')
                          : NetworkImage(data['imageUrl']),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    // width: 520.0,
                    height: 140.0,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(32.0),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).canvasColor,
                          offset: const Offset(4, 4),
                          blurRadius: 15.0,
                          spreadRadius: -1,
                          inset: true,
                        ),
                        const BoxShadow(
                          color: Colors.black,
                          offset: Offset(-4, -4),
                          blurRadius: 15.0,
                          spreadRadius: -1,
                          inset: true,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username: ${data['username']}',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Email: ${data['email']}',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
