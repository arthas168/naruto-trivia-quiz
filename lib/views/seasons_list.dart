import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/helpers/constants.dart';
import 'package:quizapp/helpers/naruto_icons.dart';
import 'package:quizapp/providers/unlocked_quizzes_provider.dart';
import 'package:quizapp/views/quiz_list_season_one.dart';
import 'package:quizapp/views/user_menu.dart';
import 'package:quizapp/widgets/widgets.dart';

class SeasonsList extends StatefulWidget {
  @override
  _SeasonsListState createState() => _SeasonsListState();
}

class _SeasonsListState extends State<SeasonsList> {
  @override
  Widget build(BuildContext context) {
    final unlockedQuizzesProvider =
        Provider.of<UnlockedQuizzesProvider>(context);

    return Scaffold(
      backgroundColor: SECONDARY_COLOR,
      appBar: AppBar(
          leading: Coins(),
          title: appBar(context),
          actions: [
            UserMenuActions(),
          ],
          centerTitle: true,
          backgroundColor: MAIN_COLOR,
          elevation: 0,
          brightness: Brightness.light),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 200.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizListSeasonOne(
                          unlockedQuizzes:
                              unlockedQuizzesProvider.numOfUnlockedQuizzes,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    height: 150,
                    width: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          const Image(
                            image: AssetImage(
                              'assets/naruto_beginning.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                          Container(
                            color: Colors.black38,
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Naruto: The beginning",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizListSeasonOne(
                          unlockedQuizzes:
                              unlockedQuizzesProvider.numOfUnlockedQuizzes,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.only(right: 40),
                    width: 170.0,
                    child: const Icon(
                      Naruto.seal_5150534,
                      color: SECONDARY_COLOR,
                      size: 92,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Image(
            image: AssetImage(
              'assets/naruto_shipuuden.png',
            ),
            height: 225,
          ),
        ],
      ),
    );
  }
}
