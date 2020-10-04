import "package:flutter/material.dart";
import 'package:quizapp/widgets/widgets.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {

  final _formKey = GlobalKey<FormState>();
  String imageUrl, title, description;

  createQuiz () {
    if (_formKey.currentState.validate()){
      print("Creating form...");
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
          brightness: Brightness.light
      ),
      body: Container(
        child:
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children:[
                      SizedBox(
                          height: 10
                      ),
                      TextFormField(
                        //  TODO: fix this
                        // ignore: missing_return
                        validator: (value){

                          if(value.length == 0) {
                            return "Please enter title.";
                          }

                          if(value.length < 3){
                            return "Title must be at least 3 characters long.";
                          }

                        },
                        decoration: InputDecoration(
                            hintText: "Title"
                        ),
                        onChanged:(val){
                          title = val;
                        },
                      ),
                      TextFormField(
                        //  TODO: fix this
                        // ignore: missing_return
                        validator: (value){

                          if(value.length == 0) {
                            return "Please enter description.";
                          }

                          if(value.length < 6){
                            return "Description must be at least 6 characters long.";
                          }

                        },
                        decoration: InputDecoration(
                            hintText: "Description"
                        ),
                        onChanged:(val){
                          title = val;
                        },
                      ),

                      Spacer(),

                      GestureDetector(
                        onTap: (){
                          print("Tapping...");
                          createQuiz();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width - 48,
                            alignment: Alignment.center,
                            child: Text("Create Quiz",
                                style: TextStyle(
                                    color:Colors.white,
                                    fontSize: 16
                                ))
                        ),
                      ),
                      SizedBox(
                          height: 30
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

