import "package:flutter/material.dart";
import 'package:quizapp/widgets/widgets.dart';

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
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          brightness: Brightness.light
      ),
      body: Container(

      )
    );
  }
}
