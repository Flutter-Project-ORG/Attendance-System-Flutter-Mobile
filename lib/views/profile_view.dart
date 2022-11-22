import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:badges/badges.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../view_model/profile_view_model.dart';
import '../view_model/excuse_view_model.dart';
import 'auth_view.dart';
import 'excuse_view.dart';

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
      body: StreamBuilder(
        stream: FirebaseDatabase.instance.ref('students/${user!.uid}').onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data != null &&
              snapshot.hasData &&
              snapshot.data!.snapshot.value != null) {
            final Map<dynamic, dynamic> data =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
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
                            },
                          ),
                        ),
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundImage: imageProvider,
                            ),
                            imageUrl: data['imageUrl'] ??
                                'https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png',
                            placeholder: (context, _) =>
                                Image.memory(kTransparentImage),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(16.0),
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
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Email: ${data['email']}',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 32.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Text('Your subjects'),
                    if (data['subjects'] != null)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data['subjects'].length,
                        itemBuilder: (BuildContext context, int index) {
                          Map subjects = data['subjects'];
                          List subjectsId = subjects.keys.toList();
                          final singleSubject = subjects[subjectsId[index]];
                          return ListTile(
                            title: Text(
                              singleSubject['subName'],
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            leading: Text(
                              '${index + 1}',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color:
                                  Theme.of(context).textTheme.headline4!.color,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider(
                                    create: (_) => ExcuseViewModel(),
                                    child: ExcuseView(
                                      subName: singleSubject['subName'],
                                      subId: subjectsId[index],
                                      insId: singleSubject['insId'],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: Text('Something wrong. Check you connection.'),
          );
        },
      ),
    );
  }
}
