import 'package:attendance_system_flutter_mobile/views/navigation_view.dart';
import 'package:attendance_system_flutter_mobile/views/signup-view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Log_in extends StatefulWidget {
  const Log_in({super.key});

  @override
  State<Log_in> createState() => _Log_inState();
}

class _Log_inState extends State<Log_in> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'log in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('log in '),
                      onPressed: () async {
                        try {
                          FirebaseAuth myauthobject = FirebaseAuth.instance;
                          UserCredential loginguser =
                              await myauthobject.signInWithEmailAndPassword(
                                  email: nameController.text,
                                  password: passwordController.text);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const nav();
                            },
                          ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Container(
                            height: 30,
                            width: 75,
                            child: Text("sorry something wrong "),
                          )));
                        }
                      },
                    )),
                Row(
                  children: <Widget>[
                    const Text("Dosen't have an account ?"),
                    TextButton(
                      child: const Text(
                        'Sign UP',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          },
                        ));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            )));
  }
}
