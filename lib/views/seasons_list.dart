import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/helpers/constants.dart';
import 'package:quizapp/helpers/naruto_icons.dart';
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
            height: 50,
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
                        builder: (context) => QuizListSeasonOne(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: MAIN_COLOR,
                        borderRadius: BorderRadius.circular(30)),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: 225.0,
                    child: const Center(
                      child: Text(
                        "Naruto",
                        style: TextStyle(
                            color: SECONDARY_COLOR,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30)),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: 225.0,
                  child: const Icon(
                    Naruto.seal_5150534,
                    color: SECONDARY_COLOR,
                    size: 92,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Image(
            image: AssetImage(
              'assets/ramen.png',
            ),
            height: 92,
          ),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
}
