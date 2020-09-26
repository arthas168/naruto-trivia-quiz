import "package:flutter/material.dart";
import 'package:quizapp/views/signIn.dart';
import 'package:quizapp/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  String name, email, password, repeatPassword;

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
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children:[
              Spacer(),
              TextFormField(
                validator: (value){
                  return value.isEmpty ? "Please enter name." : null;
                },
                decoration: InputDecoration(
                    hintText: "Name"
                ),
                onChanged:(val){
                  name = val;
                },
              ),
              TextFormField(
                validator: (value){
                  return value.isEmpty ? "Please enter email." : null;
                },
                decoration: InputDecoration(
                    hintText: "Email"
                ),
                onChanged:(val){
                  email = val;
                },
              ),
              SizedBox(
                  height: 6
              ),
              TextFormField(
                validator: (value){
                  return value.isEmpty ? "Please enter password." : null;
                },
                decoration: InputDecoration(
                    hintText: "Password"
                ),
                onChanged:(val){
                  repeatPassword = val;
                },
              ),
              TextFormField(
                validator: (value){
                  return value.isEmpty ? "Please enter password again." : null;
                },
                decoration: InputDecoration(
                    hintText: "Repeat Password"
                ),
                onChanged:(val){
                  email = val;
                },
              ),
              SizedBox(
                  height: 24
              ),
              GestureDetector(
                onTap: (){

                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    height: 50,
                    width: MediaQuery.of(context).size.width - 48,
                    alignment: Alignment.center,
                    child: Text("Sign Up",
                        style: TextStyle(
                            color:Colors.white,
                            fontSize: 16
                        ))
                ),
              ),
              SizedBox(
                  height: 18
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => SignIn()
                      ));
                    },
                    child: Text("Click here.", style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline
                    )),
                  )
                ],
              ),
              SizedBox(
                  height: 50
              ),
            ],),
        ),
      ),
    );;
  }
}
