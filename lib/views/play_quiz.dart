import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/helpers/constants.dart';
import 'package:quizapp/helpers/points.dart';
import 'package:quizapp/models/question_model.dart';
import 'package:quizapp/providers/coins_provider.dart';
import 'package:quizapp/providers/maxed_out_quizzes_provider.dart';
import 'package:quizapp/providers/unlocked_quizzes_provider.dart';
import 'package:quizapp/services/ad_service.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/results.dart';
import 'package:quizapp/widgets/play_quiz.dart';
import 'package:quizapp/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  final int quizIndex;

  const PlayQuiz(this.quizId, this.quizIndex);

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int totalAnswers = 0;
int _correctAnswers = 0;
int _incorrectAnswers = 0;
int _notAnsweredQuestions = 0;

int currentIndex = 0;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = DatabaseService();
  QuerySnapshot questionSnapshot;
  final ams = AdMobService();

  QuestionModel getModelFromSnapshot(DocumentSnapshot questionSnapshot) {
    final QuestionModel questionModel = QuestionModel();
    questionModel.question = questionSnapshot.data()["question"].toString();

    final List<String> options = [
      questionSnapshot.data()["option1"].toString(),
      questionSnapshot.data()["option2"].toString(),
      questionSnapshot.data()["option3"].toString(),
      questionSnapshot.data()["option4"].toString(),
    ];

    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.data()["option1"].toString();
    questionModel.isAnswered = false;

    return questionModel;
  }

  @override
  void initState() {
    databaseService.getSpecificQuizData(widget.quizId).then((value) {
      questionSnapshot = value as QuerySnapshot;
      _correctAnswers = 0;
      _incorrectAnswers = 0;
      _notAnsweredQuestions = 0;
      totalAnswers = questionSnapshot.docs.length;
      currentIndex = 0;

      // ignore: avoid_print
      print("$totalAnswers , total");
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(questionSnapshot.docs[currentIndex].data());
    final coinsProvider = Provider.of<CoinsProvider>(context);
    final unlockedQuizzesProvider =
        Provider.of<UnlockedQuizzesProvider>(context);
    final maxedOutQuizzesProvider =
        Provider.of<MaxedOutQuizzesProvider>(context);

    final DatabaseService databaseService = DatabaseService();
    final CountDownController _controller = CountDownController();

    final InterstitialAd endOfQuizAd = ams.endOfQuizAd();
    endOfQuizAd.load();

    return Scaffold(
      backgroundColor: SECONDARY_COLOR,
      appBar: AppBar(
          title: appBar(context),
          centerTitle: true,
          backgroundColor: MAIN_COLOR,
          elevation: 0,
          brightness: Brightness.light),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          children: [
            // ignore: avoid_unnecessary_containers
            if (questionSnapshot == null)
              // ignore: avoid_unnecessary_containers
              Container(child: const Center(child: CircularProgressIndicator()))
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: QuestionTile(
                    questionModel: getModelFromSnapshot(
                        (questionSnapshot.docs)[currentIndex]),
                    index: currentIndex),
              ),
            MaterialButton(
              onPressed: () async {
                if (currentIndex + 1 != totalAnswers) {
                  setState(() {
                    currentIndex = currentIndex + 1;
                  });
                } else {
                  final packPoints = points[widget.quizId];
                  final pointsToPass = packPoints.split(",").first;
                  final pointsToGetOneCoin = packPoints.split(",")[1];
                  final pointsToGetThreeCoins = packPoints.split(",")[2];

                  if (_correctAnswers >= int.parse(pointsToPass)) {
                    // ignore: avoid_print
                    print("unlocking next...");

                    if (unlockedQuizzesProvider.numOfUnlockedQuizzes - 1 ==
                        widget.quizIndex) {
                      unlockedQuizzesProvider.setNumOfUnlockedQuizzes(
                          unlockedQuizzesProvider.numOfUnlockedQuizzes + 1);
                    }
                  }

                  if (_correctAnswers == int.parse(pointsToGetOneCoin)) {
                    // ignore: avoid_print
                    print("adding 1 coin...");
                    final currentPointsInt = int.parse(coinsProvider.coins);
                    coinsProvider.setCoins((currentPointsInt + 1).toString());

                    final Map<String, String> coinsMap = {
                      "coins": coinsProvider.coins,
                    };

                    final currentUser = await databaseService.getCurrentUser();

                    databaseService.addUserCoins(
                        coinsMap, currentUser.email.toString());
                  }

                  if (_correctAnswers == int.parse(pointsToGetThreeCoins)) {
                    // ignore: avoid_print


                    final currentUser = await databaseService.getCurrentUser();

                    var maxedOutCurrent =
                        maxedOutQuizzesProvider.maxedOutQuizzes;

                    if(!maxedOutCurrent.contains(widget.quizId)) {

                      print("adding 3 coins...");
                      final currentPointsInt = int.parse(coinsProvider.coins);
                      coinsProvider.setCoins((currentPointsInt + 3).toString());

                      final Map<String, String> coinsMap = {
                        "coins": coinsProvider.coins,
                      };

                      maxedOutCurrent += ",${widget.quizId}";

                      maxedOutQuizzesProvider.setMaxedOutQuizzes(maxedOutCurrent);

                      databaseService.addUserCoins(
                          coinsMap, currentUser.email.toString());
                    }
                  }

                  endOfQuizAd.show();

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Results(
                              correct: _correctAnswers,
                              incorrect: _incorrectAnswers,
                              total: totalAnswers)));
                }
              },
              color: MAIN_COLOR,
              textColor: Colors.white,
              minWidth: 100,
              height: 50,
              child: Text(currentIndex + 1 != totalAnswers ? "Next" : "Finish",
                  style: const TextStyle(fontSize: 18, color: SECONDARY_COLOR)),
            ),
            CircularCountDownTimer(
              // Countdown duration in Seconds
              duration: 17,

              // Controller to control (i.e Pause, Resume, Restart) the Countdown
              controller: _controller,

              key: UniqueKey(),

              // Width of the Countdown Widget
              width: MediaQuery.of(context).size.width / 4,

              // Height of the Countdown Widget
              height: MediaQuery.of(context).size.height / 4,

              // Default Color for Countdown Timer
              color: SECONDARY_COLOR,

              // Filling Color for Countdown Timer
              fillColor: MAIN_COLOR,

              // Border Thickness of the Countdown Circle
              strokeWidth: 5.0,

              // Begin and end contours with a flat edge and no extension
              strokeCap: StrokeCap.butt,

              // Text Style for Countdown Text
              textStyle: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),

              // true for reverse countdown (max to 0), false for forward countdown (0 to max)
              isReverse: true,

              // true for reverse animation, false for forward animation
              isReverseAnimation: true,

              // Function which will execute when the Countdown Ends
              onComplete: () async {
                // Here, do whatever you want
                if (currentIndex + 1 != totalAnswers) {
                  setState(() {
                    currentIndex = currentIndex + 1;
                  });
                } else {
                  // TODO: generify this with the points map for each pack
                  if (_correctAnswers >= 8) {
                    // ignore: avoid_print
                    print("unlocking next...");
                    unlockedQuizzesProvider.setNumOfUnlockedQuizzes(
                        unlockedQuizzesProvider.numOfUnlockedQuizzes + 1);
                  }

                  if (_correctAnswers == 9) {
                    final currentPointsInt = int.parse(coinsProvider.coins);
                    coinsProvider.setCoins((currentPointsInt + 1).toString());

                    final Map<String, String> coinsMap = {
                      "coins": coinsProvider.coins,
                    };

                    final currentUser = await databaseService.getCurrentUser();

                    databaseService.addUserCoins(
                        coinsMap, currentUser.email.toString());
                  }

                  if (_correctAnswers == 10) {
                    final currentPointsInt = int.parse(coinsProvider.coins);
                    coinsProvider.setCoins((currentPointsInt + 3).toString());

                    final Map<String, String> coinsMap = {
                      "coins": coinsProvider.coins,
                    };

                    final currentUser = await databaseService.getCurrentUser();

                    databaseService.addUserCoins(
                        coinsMap, currentUser.email.toString());
                  }

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Results(
                              correct: _correctAnswers,
                              incorrect: _incorrectAnswers,
                              total: totalAnswers)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  const QuestionTile({this.questionModel, this.index});

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  String _selectedOption = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.questionModel.question,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.isAnswered) {
              if (widget.questionModel.option1 ==
                  widget.questionModel.correctOption) {
                _selectedOption = widget.questionModel.option1;
                widget.questionModel.isAnswered = true;

                _correctAnswers = _correctAnswers + 1;
                _notAnsweredQuestions = _notAnsweredQuestions - 1;

                setState(() {});
              } else {
                _selectedOption = widget.questionModel.option1;
                widget.questionModel.isAnswered = true;

                _incorrectAnswers = _incorrectAnswers + 1;
                _notAnsweredQuestions = _notAnsweredQuestions - 1;

                setState(() {});
              }
            }
          },
          child: OptionTile(
            correctAnswer: widget.questionModel.correctOption,
            label: widget.questionModel.option1,
            identifier: "A",
            selectedOption: _selectedOption,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.isAnswered) {
              if (widget.questionModel.option1 ==
                  widget.questionModel.correctOption) {
                _selectedOption = widget.questionModel.option1;
                widget.questionModel.isAnswered = true;

                _correctAnswers = _correctAnswers + 1;
                _notAnsweredQuestions = _notAnsweredQuestions - 1;

                setState(() {});
              } else {
                _selectedOption = widget.questionModel.option1;
                widget.questionModel.isAnswered = true;

                _incorrectAnswers = _incorrectAnswers + 1;
                _notAnsweredQuestions = _notAnsweredQuestions - 1;

                setState(() {});
              }
            }
          },
          child: GestureDetector(
            onTap: () {
              if (!widget.questionModel.isAnswered) {
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  _selectedOption = widget.questionModel.option2;
                  widget.questionModel.isAnswered = true;

                  _correctAnswers = _correctAnswers + 1;
                  _notAnsweredQuestions = _notAnsweredQuestions - 1;

                  setState(() {});
                } else {
                  _selectedOption = widget.questionModel.option2;
                  widget.questionModel.isAnswered = true;

                  _incorrectAnswers = _incorrectAnswers + 1;
                  _notAnsweredQuestions = _notAnsweredQuestions - 1;

                  setState(() {});
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              label: widget.questionModel.option2,
              identifier: "B",
              selectedOption: _selectedOption,
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.isAnswered) {
              if (widget.questionModel.option3 ==
                  widget.questionModel.correctOption) {
                _selectedOption = widget.questionModel.option3;
                widget.questionModel.isAnswered = true;

                _correctAnswers = _correctAnswers + 1;
                _notAnsweredQuestions = _notAnsweredQuestions - 1;

                setState(() {});
              } else {
                _selectedOption = widget.questionModel.option3;
                widget.questionModel.isAnswered = true;

                _incorrectAnswers = _incorrectAnswers + 1;
                _notAnsweredQuestions = _notAnsweredQuestions - 1;

                setState(() {});
              }
            }
          },
          child: OptionTile(
            correctAnswer: widget.questionModel.correctOption,
            label: widget.questionModel.option3,
            identifier: "C",
            selectedOption: _selectedOption,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.isAnswered) {
              if (widget.questionModel.option4 ==
                  widget.questionModel.correctOption) {
                _selectedOption = widget.questionModel.option4;
                widget.questionModel.isAnswered = true;

                _correctAnswers = _correctAnswers + 1;
                _notAnsweredQuestions = _notAnsweredQuestions - 1;

                setState(() {});
              } else {
                _selectedOption = widget.questionModel.option4;
                widget.questionModel.isAnswered = true;

                _incorrectAnswers = _incorrectAnswers + 1;
                _notAnsweredQuestions = _notAnsweredQuestions - 1;

                setState(() {});
              }
            }
          },
          child: OptionTile(
            correctAnswer: widget.questionModel.correctOption,
            label: widget.questionModel.option4,
            identifier: "D",
            selectedOption: _selectedOption,
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
