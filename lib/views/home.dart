import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/helper/alert_dialogs.dart';
import 'package:quizapp/helper/constants.dart';
import 'package:quizapp/providers/coins_provider.dart';
import 'package:quizapp/providers/unlocked_quizzes_provider.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/userMenu.dart';
import 'package:quizapp/widgets/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  var preferences;
  DatabaseService databaseService = new DatabaseService();

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return QuizTile(
                        title: snapshot.data.documents[index].data()["title"],
                        quizId: snapshot.data.documents[index].data()["quizId"],
                        index: index);
                  });
        },
      ),
    );
  }

  @override
  void initState() {
    databaseService.getQuizData().then((val) {
      setState(() {
        quizStream = val;
        // preferences = await SharedPreferences.getInstance();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: quizList());
  }
}

class Coins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var coinsProvider = Provider.of<CoinsProvider>(context);
    return InkWell(
      onTap: () {
        watchAdForCoinsDialog(context);
      },
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Row(
          children: [
            Text(coinsProvider.coins, style: TextStyle(fontSize: 18)),
            SizedBox(
              width: 2.5,
            ),
            FaIcon(
              FontAwesomeIcons.coins,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String title;
  final String quizId;
  final int index;

  QuizTile({@required this.title, @required this.quizId, this.index});

  @override
  Widget build(BuildContext context) {
    var unlockedQuizzesProvider = Provider.of<UnlockedQuizzesProvider>(context);

    return GestureDetector(
      onTap: () {
        if (unlockedQuizzesProvider.numOfUnlockedQuizzes > index) {
          payCoinAndPlayQuizDialog(context, quizId);
        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          height: 75,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: unlockedQuizzesProvider.numOfUnlockedQuizzes > index
                      ? MAIN_COLOR
                      : Colors.grey,
                  width: MediaQuery.of(context).size.width - 48,
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 5),
                    ],
                  ))
            ],
          )),
    );
  }
}
