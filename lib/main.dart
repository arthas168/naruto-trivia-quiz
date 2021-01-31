import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/helpers/constants.dart';
import 'package:quizapp/helpers/functions.dart';
import 'package:quizapp/providers/coins_provider.dart';
import 'package:quizapp/providers/unlocked_quizzes_provider.dart';
import 'package:quizapp/services/ad_service.dart';
import 'package:quizapp/views/home.dart';
import 'package:quizapp/views/sign_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAdMob.instance.initialize(appId: AdMobService().getAdMobAppId());
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

  // ignore: type_annotate_public_apis, always_declare_return_types
  checkUserLoggedIn() async {
    isUserLoggedIn = await HelperFunctions.getLoggedUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final futureBuilder = FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // ignore: avoid_print
          print("Something went wrong!");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (BuildContext context) => UnlockedQuizzesProvider(),
            child: ChangeNotifierProvider(
              create: (BuildContext context) => CoinsProvider(),
              child: MaterialApp(
                // todo: disable
                  home: Home()),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        // ignore: avoid_unnecessary_containers
        return Container(
            child: const Center(
          child: CircularProgressIndicator(
            backgroundColor: MAIN_COLOR,
          ),
        ));
      },
    );
    return futureBuilder;
  }
}
