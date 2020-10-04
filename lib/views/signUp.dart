import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/views/signIn.dart';
import 'package:quizapp/widgets/widgets.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  String name, email, password;
  AuthService authService = new AuthService();

  bool _isLoading = false;
  bool _isEmailAlreadyInUse = false;

  // TODO: Make this generic and export to 'utils' folder
  createAlertDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Icon(IconData(59137, fontFamily: 'MaterialIcons'), color: Colors.red),
        content: Text("Email address \"" + email + "\" is already in use."),
        actions: [
          MaterialButton(
            child: Text("CLOSE"),
            onPressed: (){
              Navigator.of(context, rootNavigator: true).pop('dialog');
            }
          )
        ],
      );
    });
  }


  signUp() async {
    if(_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.signUpWithEmailAndPassword(email, password).then((value){
        if(value != null){
          setState(() {
            _isLoading = false;
          });
          if(value.toString().substring(0,1) != "["){
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Home()
            ));
          }else{
            // TODO: Make this more generic and export to 'utils' folder
            int lastSquareBracketIndex = value.toString().substring(1).indexOf("]");
            if(value.toString().substring(0, lastSquareBracketIndex + 2) == "[firebase_auth/email-already-in-use]"){
              createAlertDialog(context);
            }
          }

        }
        else{
          print("Invalid request.");
          setState(() {
            _isLoading = false;
          });
        }
      });
    }else{
      print ("Form values are invalid.");
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
      body: _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :
      Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children:[
              Spacer(),
              TextFormField(
                validator: (value){
                  if(value.length == 0) {
                    return "Please enter name.";
                  }

                  if(value.length < 3){
                    return "Name must be at least 3 characters long.";
                  }

                  return null;
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

                  if(_isEmailAlreadyInUse){
                    return "Email address already in use.";
                  }

                  if(value.length == 0){
                    return "Please enter email address.";
                  }

                  // TODO: extract this in utils folder
                  bool isValidEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

                  if(!isValidEmail){
                    return "Please enter a valid email address.";
                  }

                  return null;

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

                  if(value.length == 0){
                    return "Please enter password.";
                  }

                  if(value.length < 6){
                    return "Password must be at least 6 characters long.";
                  }

                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Password"
                ),
                onChanged:(val){
                  password = val;
                },
              ),
              SizedBox(
                  height: 24
              ),
              GestureDetector(
                onTap: (){
                  print("Tapping...");
                  signUp();
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
                  height: 10
              ),
            ],),
        ),
      ),
    );
  }
}
