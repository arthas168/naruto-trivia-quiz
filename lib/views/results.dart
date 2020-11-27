import "package:flutter/material.dart";
import 'package:quizapp/helper/constants.dart';
import 'package:quizapp/widgets/widgets.dart';

class Results extends StatefulWidget {
  final int correct, incorrect, total;

  const Results(
      {Key key,
      @required this.correct,
      @required this.incorrect,
      @required this.total})
      : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: appBar(context),
            centerTitle: true,
            backgroundColor: MAIN_COLOR,
            elevation: 0,
            brightness: Brightness.light),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("You got: ${widget.correct}/${widget.total}",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    "You answered ${widget.correct} answers correctly and ${widget.incorrect} answers incorrectly. ${widget.total - (widget.correct + widget.incorrect)} questions left unanswered.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Go back to Quizzes",
                      style: TextStyle(
                          color: MAIN_COLOR,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ))));
  }
}
