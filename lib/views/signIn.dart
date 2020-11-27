import "package:flutter/material.dart";
import 'package:quizapp/helper/constants.dart';
import 'package:quizapp/helper/functions.dart';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/views/signUp.dart';
import 'package:quizapp/widgets/widgets.dart';

import 'home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthService authService = new AuthService();

  bool _isLoading = false;

  // TODO: Make this generic and export to 'utils' folder
  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Icon(IconData(59137, fontFamily: 'MaterialIcons'),
                color: Colors.red),
            content: Text(
                "There is no user registered with the email address \"" +
                    email +
                    "\"."),
            actions: [
              MaterialButton(
                  child: Text("CLOSE"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  })
            ],
          );
        });
  }

  // TODO: this is horrible ...
  createWrongPassDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Icon(IconData(59137, fontFamily: 'MaterialIcons'),
                color: Colors.red),
            content: Text("Oops! Wrong password."),
            actions: [
              MaterialButton(
                  child: Text("CLOSE"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  })
            ],
          );
        });
  }

  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService
          .signInWithEmalAndPassword(email, password)
          .then((value) {
        int lastSquareBracketIndex = value.toString().substring(1).indexOf("]");
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
      print("Form values are invalid.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: appBar(context),
          centerTitle: true,
          backgroundColor: MAIN_COLOR,
          elevation: 0,
          brightness: Brightness.light),
      body: _isLoading
          ? Container(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          : Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Spacer(),
                    TextFormField(
                      validator: (value) {
                        if (value.length == 0) {
                          return "Please enter email address.";
                        }

                        // TODO: extract this in utils folder
                        bool isValidEmail = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email);

                        if (!isValidEmail) {
                          return "Please enter a valid email address.";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Email",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: MAIN_COLOR, width: 2.0),
                        ),
                      ),
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                    SizedBox(height: 6),
                    TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value.length == 0) {
                          return "Please enter password.";
                        }

                        if (value.length < 6) {
                          return "Password must be at least 6 characters long.";
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: MAIN_COLOR, width: 2.0),
                        ),
                      ),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        print("Tapping...");
                        signIn();
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              color: MAIN_COLOR,
                              borderRadius: BorderRadius.circular(30)),
                          height: 50,
                          width: MediaQuery.of(context).size.width - 48,
                          alignment: Alignment.center,
                          child: Text("Sign In",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16))),
                    ),
                    SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text("Click here.",
                              style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline)),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }
}
