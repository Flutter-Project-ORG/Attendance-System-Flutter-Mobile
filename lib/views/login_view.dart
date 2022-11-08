import 'package:attendance_system_flutter_mobile/res/animation_enum.dart';
import 'package:attendance_system_flutter_mobile/views/navigation_view.dart';
import 'package:attendance_system_flutter_mobile/views/signup-view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rive/rive.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  Artboard? riveArtboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final passwordFocusNode = FocusNode();

  bool isLookingLeft = false;
  bool isLookingRight = false;

  void removeAllControllers() {
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerLookLeft);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerIdle);
    debugPrint("idleee");
  }

  void addHandsUpController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsUp);
    debugPrint("hands up");
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsDown);
    debugPrint("hands down");
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerSuccess);
    debugPrint("Success");
  }

  void addFailController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerFail);
    debugPrint("Faillll");
  }

  void addLookRightController() {
    removeAllControllers();
    isLookingRight = true;
    riveArtboard?.artboard.addController(controllerLookRight);
    debugPrint("Righttt");
  }

  void addLookLeftController() {
    removeAllControllers();
    isLookingLeft = true;
    riveArtboard?.artboard.addController(controllerLookLeft);
    debugPrint("Leftttttt");
  }

  void checkForPasswordFocusNodeToChangeAnimationState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandsUpController();
      } else if (!passwordFocusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);

    rootBundle.load('assets/images/login_animation.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });
    });

    checkForPasswordFocusNodeToChangeAnimationState();
  }

  void validateEmailAndPassword() {
    Future.delayed(const Duration(seconds: 1), () {
      if (formKey.currentState!.validate()) {
        addSuccessController();
      } else {
        addFailController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Animated Login')),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: riveArtboard == null
                    ? const SizedBox.shrink()
                    : Rive(
                        artboard: riveArtboard!,
                      ),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "You Must Add Email ";
                          }
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!);
                          if (!emailValid) return "Email Not Valid";
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty &&
                              value.length < 16 &&
                              !isLookingLeft) {
                            addLookLeftController();
                          } else if (value.isNotEmpty &&
                              value.length > 16 &&
                              !isLookingRight) {
                            addLookRightController();
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                      ),
                      TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          focusNode: passwordFocusNode,
                          validator: (value) {
                            if (value != null && value.isEmpty)
                              return "You Must Enter Password ";
                            return null;
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 18,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 8,
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                FirebaseAuth myauthobject =
                                    FirebaseAuth.instance;
                                UserCredential loginguser = await myauthobject
                                    .signInWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);
                                addSuccessController();

                                await Future.delayed(
                                    Duration(milliseconds: 500));
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return const nav();
                                  },
                                ));
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Container(
                                  height: 30,
                                  width: 75,
                                  child: Text("sorry something wrong "),
                                )));
                                passwordFocusNode.unfocus();
                              }
                            } else {
                              addFailController();
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
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
                                  return SignUpView();
                                },
                              ));
                            },
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}







// import 'package:attendance_system_flutter_mobile/views/navigation_view.dart';
// import 'package:attendance_system_flutter_mobile/views/signup-view.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';

// class Log_in extends StatefulWidget {
//   const Log_in({super.key});

//   @override
//   State<Log_in> createState() => _Log_inState();
// }

// class _Log_inState extends State<Log_in> {
//   TextEditingController nameController = new TextEditingController();
//   TextEditingController passwordController = new TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: Padding(
//             padding: const EdgeInsets.all(10),
//             child: ListView(
//               children: <Widget>[
//                 Container(
//                     alignment: Alignment.center,
//                     padding: const EdgeInsets.all(10),
//                     child: const Text(
//                       'log in',
//                       style: TextStyle(fontSize: 20),
//                     )),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   child: TextField(
//                     style: TextStyle(color: Colors.orange),
//                     controller: nameController,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Email',
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//                   child: TextField(
//                     style: TextStyle(color: Colors.orange),
//                     obscureText: true,
//                     controller: passwordController,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Password',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                     height: 50,
//                     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//                     child: ElevatedButton(
//                       child: const Text('log in '),
//                       onPressed: () async {
//                         try {
//                           FirebaseAuth myauthobject = FirebaseAuth.instance;
//                           UserCredential loginguser =
//                               await myauthobject.signInWithEmailAndPassword(
//                                   email: nameController.text,
//                                   password: passwordController.text);
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) {
//                               return const nav();
//                             },
//                           ));
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                               content: Container(
//                             height: 30,
//                             width: 75,
//                             child: Text("sorry something wrong "),
//                           )));
//                         }
//                       },
//                     )),
//                 Row(
//                   children: <Widget>[
//                     const Text("Dosen't have an account ?"),
//                     TextButton(
//                       child: const Text(
//                         'Sign UP',
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(
//                           builder: (context) {
//                             return SignUpScreen();
//                           },
//                         ));
//                       },
//                     )
//                   ],
//                   mainAxisAlignment: MainAxisAlignment.center,
//                 ),
//               ],
//             )));
//   }
// }
