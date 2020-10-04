import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future  signInWithEmalAndPassword(String email, String password) async {
    try {

      final authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return authResult.user.uid;

    } catch (e){
      print("ERROR SIGNING IN " + e.toString());
      return e.toString();
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {

      final authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return authResult.user.uid;

    } catch (e) {
      print("ERROR SIGNING UP " + e.toString());
      return e.toString();
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


}