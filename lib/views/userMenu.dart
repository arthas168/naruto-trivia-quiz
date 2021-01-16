import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/helper/functions.dart';
import 'package:quizapp/views/signIn.dart';

class UserMenuActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.settings,
        size: 26.0,
      ),
      onSelected: (value) => {print("value $value")},
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: ListTile(
            onTap: () async {
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
            title: Text("Log out"),
          ),
        ),
      ],
    );
  }
}
