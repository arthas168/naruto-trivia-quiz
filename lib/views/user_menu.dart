import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/helpers/constants.dart';
import 'package:quizapp/helpers/functions.dart';
import 'package:quizapp/views/sign_in.dart';

class UserMenuActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.settings, size: 26.0, color: SECONDARY_COLOR),
      // ignore: avoid_print
      onSelected: (value) => {print("value $value")},
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: ListTile(
            onTap: () async {
              // ignore: avoid_print
              print("Logging out...");
              await FirebaseAuth.instance.signOut();
              HelperFunctions.saveLoggedUserDetails(isLoggedIn: false);

              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            leading: const Icon(
              Icons.exit_to_app,
              size: 20,
            ),
            title: const Text("Log out"),
          ),
        ),
      ],
    );
  }
}
