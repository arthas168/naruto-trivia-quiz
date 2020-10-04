import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizapp/models/user.dart' as LocalUser;

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  LocalUser.User _userFromFirebaseUser(var user){
    return user != null ? LocalUser.User(userId: user.uid) : null;
  }

  Future  signInWithEmalAndPassword(String email, String password) async {
    try {

      final authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);

    } catch (e){
      print("ERROR SIGNING IN " + e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {

      final authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);

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