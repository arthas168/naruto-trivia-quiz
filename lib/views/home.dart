import "package:flutter/material.dart";
import 'package:quizapp/widgets/widgets.dart';

import 'createQuiz.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: appBar(context),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0,
          brightness: Brightness.light
      ),
      body: Container(
        child: Column(
          children: [

          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print("Add quiz");
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => CreateQuiz()
          ));
        },
      ),
    );
  }
}
