import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/providers/coins_provider.dart';
import 'package:quizapp/providers/maxed_out_quizzes_provider.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/play_quiz.dart';

Future<void> watchAdForCoinsDialog(BuildContext context) async {
  RewardedVideoAd.instance
      .load(adUnitId: "ca-app-pub-4062966075408687/6793942204");

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final coinsProvider = Provider.of<CoinsProvider>(context);
      final DatabaseService databaseService = DatabaseService();

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
              const Text('Do you want to watch one ad and get 1 coin?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final Map<String, String> coinsMap = {
                "coins": (int.parse(coinsProvider.coins) + 1).toString(),
              };

              final currentUser = await databaseService.getCurrentUser();

              // ignore: avoid_print
              print("watching ad...");
              RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event,
                  {String rewardType, int rewardAmount}) async {
                // ignore: avoid_print
                print('Rewarded event: $event');
                if (event == RewardedVideoAdEvent.rewarded) {
                  databaseService.addUserCoins(
                      coinsMap, currentUser.email.toString());

                  coinsProvider.setCoins(
                      (int.parse(coinsProvider.coins) + 1).toString());
                }
              };

              // TODO: init watching
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

Future<void> payCoinAndPlayQuizDialog(
    // ignore: avoid_positional_boolean_parameters
    BuildContext context, String quizId, int quizIndex, String maxedOutQuizzes) async {

    final bool isQuizMaxedOut = maxedOutQuizzes.contains(quizId);

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final coinsProvider = Provider.of<CoinsProvider>(context);
      final DatabaseService databaseService = DatabaseService();

      return AlertDialog(
        // ignore: prefer_const_literals_to_create_immutables
        title: Row(children: [
          Text(!isQuizMaxedOut
              ? 'Play quiz for 1 '
              : "Attention"),
          if (!isQuizMaxedOut) const FaIcon(
            FontAwesomeIcons.coins,
            size: 16,
          ) else const SizedBox(),
        ]),
        content: SingleChildScrollView(
          child: ListBody(
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              Text(!isQuizMaxedOut
                  ? 'Do you want to pay 1 coin and start the quiz now?'
                  : "You have already completed this quiz 100% correctly. You can still play, it won't cost you coins and you can't earn coins from it. Proceed?"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if(isQuizMaxedOut) {
                // ignore: avoid_print
                print("Maxed out...");
                // ignore: avoid_print
                print("loading quiz...");
                Navigator.of(context).pop();
                await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayQuiz(quizId, quizIndex)));

              }

              if (coinsProvider.coins == "0") {
                Fluttertoast.showToast(
                    msg:
                        "You don't have any coins. Click on the coins icon and watch and ad to get coins.",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.of(context).pop();
              } else {
                // ignore: avoid_print
                print("loading quiz...");
                Navigator.of(context).pop();

                coinsProvider
                    .setCoins((int.parse(coinsProvider.coins) - 1).toString());

                final Map<String, String> coinsMap = {
                  "coins": coinsProvider.coins,
                };

                final currentUser = await databaseService.getCurrentUser();

                databaseService.addUserCoins(
                    coinsMap, currentUser.email.toString());

                await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayQuiz(quizId, quizIndex)));
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
