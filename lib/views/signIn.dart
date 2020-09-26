import "package:flutter/material.dart";
import 'package:quizapp/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();
  String email, password;

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
        child: Container(
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
                  height: 80
              ),
          ],),
        ),
      ),
    );
  }
}
