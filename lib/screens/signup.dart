import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'login.dart';

class Sign_up extends StatefulWidget {
  const Sign_up({super.key});

  @override
  State<Sign_up> createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  GlobalKey<FormState> myformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Form(
          key: myformKey,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Sign UP',
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (data) {
                        if (data.toString().contains("@") == false) {
                          return 'email must have the @ symbol ! ';
                        }
                      },
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (data) {
                        if (data.toString().length <= 6) {
                          return 'the password must be at least 7 letters';
                        }
                        if (data![0].toString().codeUnits[0] > 90) {
                          return "the password should start with capital";
                        }
                      },
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
                        child: const Text('Create my Account'),
                        onPressed: () async {
                          if (myformKey.currentState!.validate()) {
                            try {
                              FirebaseAuth AuthObject = FirebaseAuth.instance;

                              UserCredential mysignupcre = await AuthObject
                                  .createUserWithEmailAndPassword(
                                      email: nameController.text,
                                      password: passwordController.text);
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Container(
                                        child: Row(
                                      children: [
                                        Text("sorry"),
                                        IconButton(
                                            onPressed: (() {
                                              passwordController.clear();
                                              nameController.clear();
                                              Navigator.pop(context);
                                            }),
                                            icon: Icon(Icons.delete))
                                      ],
                                    )),
                                  );
                                },
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Sorry something wrong")));
                            }
                          }
                        },
                      )),
                  Row(
                    children: <Widget>[
                      const Text('I have an account ?'),
                      TextButton(
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Log_in();
                            },
                          ));
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              )),
        ));
  }
}
