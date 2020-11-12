import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/models/questionModel.dart';
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

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot questionSnapshot;

  QuestionModel getModelFromSnapshot(DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();
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
    print("${widget.quizId}");
    databaseService.getSpecificQuizData(widget.quizId).then((value) {
      questionSnapshot = value;
      _correctAnswers = 0;
      _incorrectAnswers = 0;
      _notAnsweredQuestions = 0;
      totalAnswers = questionSnapshot.docs.length;

      print("$totalAnswers , total");
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: appBar(context),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0,
          brightness: Brightness.light),
      body: Container(
          child: Column(
        children: [
          questionSnapshot == null
              ? Container(child: Center(child: CircularProgressIndicator()))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: questionSnapshot.docs.length,
                  itemBuilder: (context, index) {
                    return QuestionTile(
                        questionModel:
                            getModelFromSnapshot(questionSnapshot.docs[index]),
                        index: index);
                  },
                )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Results(
                      correct: _correctAnswers,
                      incorrect: _incorrectAnswers,
                      total: totalAnswers)));
        },
      ),
    );
  }
}

class QuestionTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuestionTile({this.questionModel, this.index});

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  String _selectedOption = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          widget.questionModel.question,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 12,
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
        SizedBox(
          height: 4,
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
        SizedBox(
          height: 4,
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
        SizedBox(
          height: 4,
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
        SizedBox(
          height: 20,
        )
      ],
    ));
  }
}
