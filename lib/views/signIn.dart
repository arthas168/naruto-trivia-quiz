import "package:flutter/material.dart";
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/views/signUp.dart';
import 'package:quizapp/widgets/widgets.dart';

import 'home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthService authService = new AuthService();

  bool _isLoading = false;

  signIn() async {
    if (_formKey.currentState.validate()){

      setState(() {
        _isLoading = true;
      });

      await authService.signInWithEmalAndPassword(email, password).then((value){
        if(value != null){
          setState(() {
            _isLoading = true;
          });
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Home()
          ));
        }
      });
    } else {
      print("Form values are invalid.");
    }
  }

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
      body: _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        )
      )
      : Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children:[
              Spacer(),
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
                obscureText: true,
                validator: (value){
                  return value.isEmpty ? "Please enter password." : null;
                },
                decoration: InputDecoration(
                    hintText: "Password"
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
                  signIn();
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
                  child: Text("Sign In",
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
                  Text("Don't have an account? ",
                  style: TextStyle(
                    fontSize: 16,
                  )),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => SignUp()
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
                  height: 10
              ),
          ],),
        ),
      ),
    );
  }
}
