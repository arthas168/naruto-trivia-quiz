import "package:flutter/material.dart";
import 'package:quizapp/helpers/constants.dart';
import 'package:quizapp/helpers/functions.dart';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/views/sign_up.dart';
import 'package:quizapp/widgets/widgets.dart';

import 'home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthService authService = AuthService();

  bool _isLoading = false;

  // TODO: Make this generic and export to 'utils' folder
  Future createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(IconData(59137, fontFamily: 'MaterialIcons'),
                color: Colors.red),
            content: Text(
                // ignore: avoid_escaping_inner_quotes
                "There is no user registered with the email address \"$email\"."),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
                child: const Text("CLOSE"),
              )
            ],
          );
        });
  }

  // TODO: this is horrible ...
  Future createWrongPassDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(IconData(59137, fontFamily: 'MaterialIcons'),
                color: Colors.red),
            content: const Text("Oops! Wrong password."),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
                child: const Text("CLOSE"),
              )
            ],
          );
        });
  }

  // ignore: type_annotate_public_apis, always_declare_return_types
  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(email, password)
          .then((value) {
        final int lastSquareBracketIndex =
            value.toString().substring(1).indexOf("]");
        if (value.toString().substring(0, lastSquareBracketIndex + 2) ==
            "[firebase_auth/user-not-found]") {
          createAlertDialog(context);
          setState(() {
            _isLoading = false;
          });
          return;
        }

        if (value.toString().substring(0, lastSquareBracketIndex + 2) ==
            "[firebase_auth/wrong-password]") {
          createWrongPassDialog(context);
          setState(() {
            _isLoading = false;
          });
          return;
        }

        if (value != null) {
          setState(() {
            _isLoading = false;
          });

          HelperFunctions.saveLoggedUserDetails(isLoggedIn: true);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      });
    } else {
      // ignore: avoid_print
      print("Form values are invalid.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SECONDARY_COLOR,
      appBar: AppBar(
          title: appBar(context),
          centerTitle: true,
          backgroundColor: MAIN_COLOR,
          elevation: 0,
          brightness: Brightness.light),
      body: _isLoading
          // ignore: avoid_unnecessary_containers
          ? Container(
              child: const Center(
              child: CircularProgressIndicator(),
            ))
          : Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(),
                    TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter email address.";
                        }

                        // TODO: extract this in utils folder
                        final bool isValidEmail = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email);

                        if (!isValidEmail) {
                          return "Please enter a valid email address.";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                        ),
                      ),
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter password.";
                        }

                        if (value.length < 6) {
                          return "Password must be at least 6 characters long.";
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        hintText: "Password",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                        ),
                      ),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        signIn();
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              color: MAIN_COLOR,
                              borderRadius: BorderRadius.circular(30)),
                          height: 50,
                          width: MediaQuery.of(context).size.width - 48,
                          alignment: Alignment.center,
                          child: const Text("Sign In",
                              style: TextStyle(
                                  color: SECONDARY_COLOR, fontSize: 16))),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? ",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: const Text("Click here.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline)),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }
}
