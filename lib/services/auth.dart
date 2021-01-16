import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return authResult.user.uid;
    } catch (e) {
      // ignore: avoid_print
      print("ERROR SIGNING IN $e");
      return e.toString();
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return authResult.user.uid;
    } catch (e) {
      // ignore: avoid_print
      print("ERROR SIGNING UP $e");
      return e.toString();
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }
}
