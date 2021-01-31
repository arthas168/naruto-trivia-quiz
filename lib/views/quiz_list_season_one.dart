import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/helpers/alert_dialogs.dart';
import 'package:quizapp/helpers/constants.dart';
import 'package:quizapp/helpers/naruto_icons.dart';
import 'package:quizapp/providers/coins_provider.dart';
import 'package:quizapp/providers/unlocked_quizzes_provider.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/seasons_list.dart';
import 'package:quizapp/views/user_menu.dart';
import 'package:quizapp/widgets/widgets.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

// ignore: must_be_immutable
class QuizListSeasonOne extends StatefulWidget {
  int _unlockedQuizzes;
  QuizListSeasonOne({int unlockedQuizzes}) {
    _unlockedQuizzes = unlockedQuizzes;
  }

  @override
  // ignore: no_logic_in_create_state
  _QuizListSeasonOneState createState() =>
      _QuizListSeasonOneState(unlockedQuizzes: _unlockedQuizzes);
}

class _QuizListSeasonOneState extends State<QuizListSeasonOne> {
  Stream quizStream;
  int _unlockedQuizzes;

  _QuizListSeasonOneState({int unlockedQuizzes}) {
    _unlockedQuizzes = unlockedQuizzes;
  }

  // ignore: type_annotate_public_apis, prefer_typing_uninitialized_variables
  var preferences;
  DatabaseService databaseService = DatabaseService();

  final scrollDirection = Axis.vertical;
  AutoScrollController controller;

  Widget quizList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  controller: controller,
                  scrollDirection: scrollDirection,
                  itemCount:
                      int.parse(snapshot.data.documents.length.toString()),
                  itemBuilder: (context, index) {
                    return AutoScrollTag(
                      key: ValueKey(index),
                      controller: controller,
                      index: index,
                      child: QuizTile(
                        title: snapshot.data.documents[index]
                            .data()["title"]
                            .toString(),
                        quizId: snapshot.data.documents[index]
                            .data()["quizId"]
                            .toString(),
                        index: index,
                      ),
                    );
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

    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToIndex());
  }

  @override
  Widget build(BuildContext context) {
    print(_unlockedQuizzes);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: SECONDARY_COLOR,
          onPressed: () async {
            await Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SeasonsList()));
          },
          child: const Icon(Icons.arrow_back),
        ),
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
        body: quizList());
  }

  Future _scrollToIndex() async {
    await controller.scrollToIndex(_unlockedQuizzes - 3,
        preferPosition: AutoScrollPosition.begin);
  }
}

class Coins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final coinsProvider = Provider.of<CoinsProvider>(context);

    return InkWell(
      onTap: () {
        watchAdForCoinsDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Text(coinsProvider.coins,
                style: const TextStyle(fontSize: 18, color: SECONDARY_COLOR)),
            const SizedBox(
              width: 2.5,
            ),
            const FaIcon(FontAwesomeIcons.coins,
                size: 18, color: SECONDARY_COLOR)
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

  const QuizTile({@required this.title, @required this.quizId, this.index});

  @override
  Widget build(BuildContext context) {
    final unlockedQuizzesProvider =
        Provider.of<UnlockedQuizzesProvider>(context);

    return GestureDetector(
      onTap: () {
        if (unlockedQuizzesProvider.numOfUnlockedQuizzes > index) {
          payCoinAndPlayQuizDialog(context, quizId, index);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
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
                  if (unlockedQuizzesProvider.numOfUnlockedQuizzes > index)
                    Text(
                      title,
                      style: const TextStyle(
                          color: SECONDARY_COLOR,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    )
                  else
                    const Icon(Naruto.seal_5150534, size: 55),
                  const SizedBox(height: 5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
