import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/views/home.dart';
import 'package:quizapp/views/signIn.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("Something went wrong!");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(home: Home());
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
            child: Center(
              child: CircularProgressIndicator(),
            )
        );
      },
    );
  }
}
