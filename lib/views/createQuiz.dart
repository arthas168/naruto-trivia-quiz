import "package:flutter/material.dart";
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/addQuestion.dart';
import 'package:quizapp/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String title, description, id;

  DatabaseService databaseService = new DatabaseService();

  bool _isLoading = false;

  createQuiz() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      id = randomAlphaNumeric(16);

      Map<String, String> quizMap = {
        "quizId": id,
        "title": title,
        "description": description
      };

      await databaseService.addQuizData(quizMap, id).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AddQuestion(id)));
        });
      });
    }
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
      body: _isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Container(
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value.length == 0) {
                            return "Please enter title.";
                          }

                          if (value.length < 3) {
                            return "Title must be at least 3 characters long.";
                          }

                          return null;
                        },
                        decoration: InputDecoration(hintText: "Title"),
                        onChanged: (val) {
                          title = val;
                        },
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.length == 0) {
                            return "Please enter description.";
                          }

                          if (value.length < 6) {
                            return "Description must be at least 6 characters long.";
                          }

                          return null;
                        },
                        decoration: InputDecoration(hintText: "Description"),
                        onChanged: (val) {
                          description = val;
                        },
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          print("Tapping...");
                          createQuiz();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30)),
                            height: 50,
                            width: MediaQuery.of(context).size.width - 48,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                createQuiz();
                              },
                              child: Text("Create Quiz",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            )),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
