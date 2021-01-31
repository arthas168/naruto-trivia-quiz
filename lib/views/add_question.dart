import "package:flutter/material.dart";
import 'package:quizapp/helpers/constants.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;

  const AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String question = "", option1 = "", option2 = "", option3 = "", option4 = "";

  // ignore: type_annotate_public_apis, always_declare_return_types
  uploadQuizData() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      final Map<String, String> questionMap = {
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
      }).catchError((e) {
        // ignore: avoid_print
        print(e);
      });
    } else {
      // ignore: avoid_print
      print("error is happening ");
    }
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
        body: _isLoading
            // ignore: avoid_unnecessary_containers
            ? Container(child: const CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter question.";
                            }

                            if (value.length < 3) {
                              return "Question must be at least 3 characters long.";
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Question",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: MAIN_COLOR, width: 2.0),
                            ),
                          ),
                          onChanged: (val) {
                            question = val;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Option cannot be empty.";
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Option 1 (Correct Answer)",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: MAIN_COLOR, width: 2.0),
                            ),
                          ),
                          onChanged: (val) {
                            option1 = val;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Option cannot be empty.";
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Option 2",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: MAIN_COLOR, width: 2.0),
                            ),
                          ),
                          onChanged: (val) {
                            option2 = val;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Option cannot be empty.";
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Option 3",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: MAIN_COLOR, width: 2.0),
                            ),
                          ),
                          onChanged: (val) {
                            option3 = val;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Option cannot be empty.";
                            }

                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Option 4",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: MAIN_COLOR, width: 2.0),
                            ),
                          ),
                          onChanged: (val) {
                            option4 = val;
                          },
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                uploadQuizData();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                decoration: BoxDecoration(
                                    color: MAIN_COLOR,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Add Question",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 20,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                decoration: BoxDecoration(
                                    color: MAIN_COLOR,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Submit Quiz",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    )),
              ));
  }
}
