import "package:flutter/material.dart";
import 'package:quizapp/helpers/constants.dart';
import 'package:quizapp/widgets/widgets.dart';

import 'home.dart';

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
        backgroundColor: SECONDARY_COLOR,
        appBar: AppBar(
            title: appBar(context),
            centerTitle: true,
            backgroundColor: MAIN_COLOR,
            elevation: 0,
            brightness: Brightness.light),
        // ignore: sized_box_for_whitespace
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("You got: ${widget.correct}/${widget.total}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    "You answered ${widget.correct} answers correctly and ${widget.incorrect} answers incorrectly. \n${widget.total - (widget.correct + widget.incorrect)} questions left unanswered.",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: const Text(
                      "Go back to Home",
                      style: TextStyle(
                          color: MAIN_COLOR,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ))));
  }
}
