import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rive/rive.dart';

import '../res/components.dart';
import '../res/text_field_theme.dart';
import '../view_model/auth_view_model.dart';
import '../res/animation_enum.dart';
import '../views/navigation_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  Artboard? riveArtBoard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final passwordFocusNode = FocusNode();

  bool isLookingLeft = false;
  bool isLookingRight = false;

  void removeAllControllers() {
    riveArtBoard?.artboard.removeController(controllerIdle);
    riveArtBoard?.artboard.removeController(controllerHandsUp);
    riveArtBoard?.artboard.removeController(controllerHandsDown);
    riveArtBoard?.artboard.removeController(controllerLookLeft);
    riveArtBoard?.artboard.removeController(controllerLookRight);
    riveArtBoard?.artboard.removeController(controllerSuccess);
    riveArtBoard?.artboard.removeController(controllerFail);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerIdle);
  }

  void addHandsUpController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerHandsUp);
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerHandsDown);
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerSuccess);
  }

  void addFailController() {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerFail);
  }

  void addLookRightController() {
    removeAllControllers();
    isLookingRight = true;
    riveArtBoard?.artboard.addController(controllerLookRight);
  }

  void addLookLeftController() {
    removeAllControllers();
    isLookingLeft = true;
    riveArtBoard?.artboard.addController(controllerLookLeft);
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

  bool isLogin = true;
  final AuthViewModel _viewModel = AuthViewModel();

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
      final artBoard = file.mainArtboard;
      artBoard.addController(controllerIdle);
      setState(() {
        riveArtBoard = artBoard;
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
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Text("Students Attendance"),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: riveArtBoard == null
                    ? const SizedBox.shrink()
                    : Rive(
                        artboard: riveArtBoard!,
                      ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 25,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    if (!isLogin)
                      TextFormField(
                        key: const Key('user'),
                        controller: usernameController,
                        style: Theme.of(context).textTheme.labelMedium,
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          border: TextFieldTheme.border1,
                          enabledBorder: TextFieldTheme.border2,
                        ),
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return "Please enter a username";
                          }
                          if (value!.length < 3) {
                            return "Username must have 3 character at least";
                          }
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
                    if (!isLogin)
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                      ),
                    TextFormField(
                      key: const Key('email'),
                      controller: emailController,
                      style: Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        border: TextFieldTheme.border1,
                        enabledBorder: TextFieldTheme.border2,
                      ),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please enter an email";
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
                      key: const Key('pass'),
                      controller: passwordController,
                      style: Theme.of(context).textTheme.labelMedium,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        border: TextFieldTheme.border1,
                        enabledBorder: TextFieldTheme.border2,
                      ),
                      focusNode: passwordFocusNode,
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return "Please enter a password";
                        }
                        if (value!.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 18,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 8,
                      ),
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                });
                            final NavigatorState navigator =
                                Navigator.of(context);
                            try {
                              if (isLogin) {
                                await _viewModel.login(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim());
                              } else {
                                await _viewModel.signUp(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  username: usernameController.text.trim(),
                                );
                              }
                              addSuccessController();
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              navigator.pop();
                              navigator.pushReplacement(MaterialPageRoute(
                                  builder: (_) => const NavView()));
                            } on FirebaseAuthException catch (e) {
                              navigator.pop();
                              String err = e.code.toLowerCase();
                              String message = '';
                              if (err == 'EMAIL_EXISTS') {
                                message =
                                    'The email address is already in use by another account.';
                              } else if (err == 'TOO_MANY_ATTEMPTS_TRY_LATER') {
                                message =
                                    'We have blocked all requests from this device due to unusual activity. Try again later.';
                              } else if (err == 'EMAIL_NOT_FOUND') {
                                message =
                                    'There is no user record corresponding to this identifier. The user may have been deleted.';
                              } else if (err == 'INVALID_PASSWORD') {
                                message =
                                    'The password is invalid or the user does not have a password.';
                              } else if (err == 'USER_DISABLED') {
                                message =
                                    'The user account has been disabled by an administrator.';
                              } else {
                                message = 'Something went wrong. Try again.';
                              }
                              Components.showErrorSnackBar(context,
                                  text: message);
                            } catch (e) {
                              navigator.pop();
                              String msg = 'Try again.';
                              if (e.toString() == 'User not found.') {
                                msg = e.toString();
                              }
                              Components.showErrorSnackBar(context, text: msg);
                              passwordFocusNode.unfocus();
                            }
                          } else {
                            addFailController();
                          }
                        },
                        child: Text(
                          isLogin ? 'Login' : 'Sign Up',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(isLogin
                              ? "Doesn't have an account? "
                              : "Already have an account? "),
                          TextButton(
                            child: Text(
                              isLogin ? 'Sign UP' : 'Login',
                              style: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
