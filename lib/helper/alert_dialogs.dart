import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/providers/coins_provider.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/play_quiz.dart';

Future<void> watchAdForCoinsDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      var coinsProvider = Provider.of<CoinsProvider>(context);
      DatabaseService databaseService = DatabaseService();

      return AlertDialog(
        // ignore: prefer_const_literals_to_create_immutables
        title: Row(children: [
          const Text('Watch ad for 1 '),
          const FaIcon(
            FontAwesomeIcons.coins,
            size: 16,
          ),
        ]),
        content: SingleChildScrollView(
          child: ListBody(
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              const Text(
                  'Do you want to watch one ad (30 seconds) and get 1 coin?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Map<String, String> coinsMap = {
                "coins": (int.parse(coinsProvider.coins) + 1).toString(),
              };

              var currentUser = await databaseService.getCurrentUser();

              databaseService.addUserCoins(
                  coinsMap, currentUser.email.toString());

              coinsProvider.setCoins((int.parse(coinsProvider.coins)+1).toString());

              print("watching ad...");
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}

Future<void> payCoinAndPlayQuizDialog(BuildContext context, String quizId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final coinsProvider = Provider.of<CoinsProvider>(context);
      final DatabaseService databaseService = DatabaseService();

      return AlertDialog(
        // ignore: prefer_const_literals_to_create_immutables
        title: Row(children: [
          const Text('Play quiz for 1 '),
          const FaIcon(
            FontAwesomeIcons.coins,
            size: 16,
          ),
        ]),
        content: SingleChildScrollView(
          child: ListBody(
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              const Text(
                  'Do you want to pay 1 coin and start the quiz now?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if(coinsProvider.coins == "0"){
                Fluttertoast.showToast(
                    msg: "You don't have any coins. Click on the coins icon and watch and ad to get coins.",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.of(context).pop();
              }else{
                print("loading quiz...");
                Navigator.of(context).pop();

                coinsProvider.setCoins((int.parse(coinsProvider.coins)-1).toString());

                Map<String, String> coinsMap = {
                  "coins": coinsProvider.coins,
                };

                final currentUser = await databaseService.getCurrentUser();

                databaseService.addUserCoins(
                    coinsMap, currentUser.email.toString());

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => PlayQuiz(quizId)));
              }
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}