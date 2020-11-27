import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:quizapp/helper/constants.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/playQuiz.dart';
import 'package:quizapp/widgets/widgets.dart';

import 'createQuiz.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  // final user = databaseService.getCurrentUser();

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
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: appBar(context),
          centerTitle: true,
          backgroundColor: MAIN_COLOR,
          elevation: 0,
          brightness: Brightness.light),
      body: quizList(),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: MAIN_COLOR,
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     print("Add quiz");
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => CreateQuiz()));
      //   },
      // ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String title;
  final String quizId;

  QuizTile({@required this.title, @required this.quizId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayQuiz(quizId)));
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          height: 75,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: MAIN_COLOR,
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
