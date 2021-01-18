import "package:flutter/material.dart";
import 'package:quizapp/helpers/constants.dart';
import 'package:quizapp/services/database.dart';
import 'package:quizapp/views/add_question.dart';
import 'package:quizapp/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String title, id;

  DatabaseService databaseService = DatabaseService();

  bool _isLoading = false;

  // ignore: type_annotate_public_apis, always_declare_return_types
  createQuiz() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      id = randomAlphaNumeric(16);

      final Map<String, String> quizMap = {
        "quizId": id,
        "title": title,
      };

      await databaseService.addQuizData(quizMap, id).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddQuestion(id)));
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
          backgroundColor: MAIN_COLOR,
          elevation: 0,
          brightness: Brightness.light),
      body: _isLoading
          // ignore: avoid_unnecessary_containers
          ? Container(child: const Center(child: CircularProgressIndicator()))
          // ignore: avoid_unnecessary_containers
          : Container(
              child: Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter title.";
                          }

                          if (value.length < 3) {
                            return "Title must be at least 3 characters long.";
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Title",
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: MAIN_COLOR, width: 2.0),
                          ),
                        ),
                        onChanged: (val) {
                          title = val;
                        },
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          createQuiz();
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                color: MAIN_COLOR,
                                borderRadius: BorderRadius.circular(30)),
                            height: 50,
                            width: MediaQuery.of(context).size.width - 48,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                createQuiz();
                              },
                              child: const Text("Create Quiz",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            )),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
