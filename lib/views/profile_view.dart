import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          children: [
            CircleAvatar(
              radius: 90,
              foregroundImage: AssetImage("assets/images/avatar.png"),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.indigo.shade400,
              child: ListTile(
                title: Text(
                  "${FirebaseAuth.instance.currentUser!.email}",
                ),
                subtitle: Text(
                  "Email",
                  style: TextStyle(
                    fontFamily: "Lobster",
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            Container(
              child: ListTile(
                tileColor: Colors.teal.shade400,
                title: Text(
                  "962 780 000 000",
                  style: TextStyle(
                    fontFamily: "Lobster",
                    fontSize: 30,
                  ),
                ),
                subtitle: Text(
                  "Mobile",
                  style: TextStyle(
                    fontFamily: "Lobster",
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
