import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/helper/constants.dart';
import 'package:quizapp/helper/functions.dart';
import 'package:quizapp/providers/coins_provider.dart';
import 'package:quizapp/providers/unlocked_quizzes_provider.dart';
import 'package:quizapp/views/home.dart';
import 'package:quizapp/views/signIn.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool isUserLoggedIn = false;

  @override
  void initState() {
    checkUserLoggedIn();
    super.initState();
  }

  checkUserLoggedIn() async {
    isUserLoggedIn = await HelperFunctions.getLoggedUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("Something went wrong!");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (BuildContext context) => UnlockedQuizzesProvider(),
            child: ChangeNotifierProvider(
              create: (BuildContext context) => CoinsProvider(),
              child: MaterialApp(
                  home: (isUserLoggedIn ?? false) ? Home() : SignIn()),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
            child: Center(
          child: CircularProgressIndicator(
            backgroundColor: MAIN_COLOR,
          ),
        ));
      },
    );
    return futureBuilder;
  }
}
