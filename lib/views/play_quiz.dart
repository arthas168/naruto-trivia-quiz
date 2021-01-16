import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/helper/constants.dart';
import 'package:quizapp/models/questionModel.dart';
import 'package:quizapp/providers/coins_provider.dart';
import 'package:quizapp/providers/unlocked_quizzes_provider.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/results.dart';
import 'package:quizapp/widgets/playQuiz.dart';
import 'package:quizapp/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;

  PlayQuiz(this.quizId);

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int totalAnswers = 0;
int _correctAnswers = 0;
int _incorrectAnswers = 0;
int _notAnsweredQuestions = 0;

int currentIndex = 0;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot questionSnapshot;

  QuestionModel getModelFromSnapshot(DocumentSnapshot questionSnapshot) {
    final QuestionModel questionModel = QuestionModel();
    questionModel.question = questionSnapshot.data()["question"];

    List<String> options = [
      questionSnapshot.data()["option1"],
      questionSnapshot.data()["option2"],
      questionSnapshot.data()["option3"],
      questionSnapshot.data()["option4"],
    ];

    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.data()["option1"];
    questionModel.isAnswered = false;

    return questionModel;
  }

  @override
  void initState() {
    databaseService.getSpecificQuizData(widget.quizId).then((value) {
      questionSnapshot = value;
      _correctAnswers = 0;
      _incorrectAnswers = 0;
      _notAnsweredQuestions = 0;
      totalAnswers = questionSnapshot.docs.length;
      currentIndex = 0;

      print("$totalAnswers , total");
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(questionSnapshot.docs[currentIndex].data());
    final coinsProvider = Provider.of<CoinsProvider>(context);
    final unlockedQuizzesProvider = Provider.of<UnlockedQuizzesProvider>(context);

    final DatabaseService databaseService = DatabaseService();

    CountDownController _controller = CountDownController();

    return Scaffold(
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
            if (questionSnapshot == null) Container(child: const Center(child: CircularProgressIndicator())) else Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: QuestionTile(
                        questionModel: getModelFromSnapshot(
                            sortByDate(questionSnapshot.docs)[currentIndex]),
                        index: currentIndex),
                  ),
            MaterialButton(
              onPressed: () async {
                if (currentIndex + 1 != totalAnswers) {
                  setState(() {
                    currentIndex = currentIndex + 1;
                  });
                } else {
                  // TODO: generify this with the points map for each pack
                  if (_correctAnswers >= 8) {
                    // TODO: unlock next
                    print("unlocking next...");
                    unlockedQuizzesProvider.setNumOfUnlockedQuizzes(
                        unlockedQuizzesProvider.numOfUnlockedQuizzes + 1);
                  }

                  if (_correctAnswers == 9) {
                    // TODO: add 1 coin
                    final currentPointsInt = int.parse(coinsProvider.coins);
                    coinsProvider.setCoins((currentPointsInt + 1).toString());

                    Map<String, String> coinsMap = {
                      "coins": coinsProvider.coins,
                    };

                    final currentUser = await databaseService.getCurrentUser();

                    databaseService.addUserCoins(
                        coinsMap, currentUser.email.toString());
                  }

                  if (_correctAnswers == 10) {
                    // TODO: add 3 coins
                    final currentPointsInt = int.parse(coinsProvider.coins);
                    coinsProvider.setCoins((currentPointsInt + 3).toString());

                    Map<String, String> coinsMap = {
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
              color: MAIN_COLOR,
              textColor: Colors.white,
              minWidth: 100,
              height: 50,
              child: Text(currentIndex + 1 != totalAnswers ? "Next" : "Finish",
                  style: const TextStyle(fontSize: 18)),
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
              color: Colors.white,

              // Filling Color for Countdown Timer
              fillColor: Colors.red,

              // Background Color for Countdown Widget
              backgroundColor: null,

              // Border Thickness of the Countdown Circle
              strokeWidth: 5.0,

              // Begin and end contours with a flat edge and no extension
              strokeCap: StrokeCap.butt,

              // Text Style for Countdown Text
              textStyle: const TextStyle(
                  fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),

              // true for reverse countdown (max to 0), false for forward countdown (0 to max)
              isReverse: true,

              // true for reverse animation, false for forward animation
              isReverseAnimation: true,

              // Optional [bool] to hide the [Text] in this widget.
              isTimerTextShown: true,

              // Function which will execute when the Countdown Ends
              onComplete: () async {
                // Here, do whatever you want
                print('Countdown Ended');
                if (currentIndex + 1 != totalAnswers) {
                  setState(() {
                    currentIndex = currentIndex + 1;
                  });

                } else {
                  // TODO: generify this with the points map for each pack
                  if (_correctAnswers >= 8) {
                    // TODO: unlock next
                    print("unlocking next...");
                    unlockedQuizzesProvider.setNumOfUnlockedQuizzes(
                        unlockedQuizzesProvider.numOfUnlockedQuizzes + 1);
                  }

                  if (_correctAnswers == 9) {
                    // TODO: add 1 coin
                    final currentPointsInt = int.parse(coinsProvider.coins);
                    coinsProvider.setCoins((currentPointsInt + 1).toString());

                    Map<String, String> coinsMap = {
                      "coins": coinsProvider.coins,
                    };

                    final currentUser = await databaseService.getCurrentUser();

                    databaseService.addUserCoins(
                        coinsMap, currentUser.email.toString());
                  }

                  if (_correctAnswers == 10) {
                    // TODO: add 3 coins
                    final currentPointsInt = int.parse(coinsProvider.coins);
                    coinsProvider.setCoins((currentPointsInt + 3).toString());

                    Map<String, String> coinsMap = {
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
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
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

List<QueryDocumentSnapshot> sortByDate(List<QueryDocumentSnapshot> docs) {
  docs.sort((a, b) => a["date"].compareTo(b["date"]));
  return docs;
}
