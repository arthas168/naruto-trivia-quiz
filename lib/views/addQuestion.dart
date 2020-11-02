import "package:flutter/material.dart";
import 'package:quizapp/services/database.dart';
import 'package:quizapp/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {

  final String quizId;
  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String question = "", option1 = "", option2 = "", option3 = "", option4 = "";

  uploadQuizData() {

    if (_formKey.currentState.validate()) {

      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };

      databaseService.addQuestionData(questionMap, widget.quizId).then((value) {
        question = "";
        option1 = "";
        option2 = "";
        option3 = "";
        option4 = "";
        setState(() {
          _isLoading = false;
        });

      }).catchError((e){
        print(e);
      });


    }else{
      print("error is happening ");
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
        body: _isLoading ? Container(
          child: CircularProgressIndicator()
        ) : Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value.length == 0) {
                    return "Please enter question.";
                  }

                  if (value.length < 3) {
                    return "Question must be at least 3 characters long.";
                  }

                  return null;
                },
                decoration: InputDecoration(hintText: "Question"),
                onChanged: (val) {
                  question = val;
                },
              ),
              SizedBox(
                height: 3,
              ),
              TextFormField(
                validator: (value) {
                  if (value.length == 0) {
                    return "Option cannot be empty.";
                  }

                  return null;
                },

                decoration: InputDecoration(hintText: "Option 1 (Correct Answer)"),
                onChanged: (val) {
                  option1 = val;
                },
              ),
              SizedBox(
                height: 3,
              ),
              TextFormField(

                validator: (value) {
                  if (value.length == 0) {
                    return "Option cannot be empty.";
                  }

                  return null;
                },
                decoration: InputDecoration(hintText: "Option 2"),
                onChanged: (val) {
                  option2 = val;
                },
              ),
              SizedBox(
                height: 3,
              ),
              TextFormField(

                validator: (value) {
                  if (value.length == 0) {
                    return "Option cannot be empty.";
                  }

                  return null;
                },
                decoration: InputDecoration(hintText: "Option 3"),
                onChanged: (val) {
                  option3 = val;
                },
              ),
              SizedBox(
                height: 3,
              ),
              TextFormField(
                validator: (value) {
                  if (value.length == 0) {
                    return "Option cannot be empty.";
                  }

                  return null;
                },
                decoration: InputDecoration(hintText: "Option 4"),
                onChanged: (val) {
                  option4 = val;
                },
              ),
              Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Submit",
                        style:
                        TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      uploadQuizData();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Add Question",
                        style:
                        TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          )),
        ));
  }
}
