import "package:flutter/material.dart";

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
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${widget.correct}/${widget.total}"),
                SizedBox(height: 8),
                Text(
                    "You answered ${widget.correct} answers correctly and ${widget.incorrect} answers incorrectly"),
                SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Go back to Quizzes",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ))));
  }
}
