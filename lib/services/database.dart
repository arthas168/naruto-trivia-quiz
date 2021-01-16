import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  Future<void> addQuizData(Map quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addQuestionData(Map questionData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QuestionAndAnswer")
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addUserCoins(Map<String, String> coinsData, String userEmail) async {
    await FirebaseFirestore.instance
        .collection("UserCoins")
        .doc(userEmail)
        .set(coinsData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addAvailableQuizzes(Map<String, int> quizzesData) async {

    final user = await getCurrentUser();
    final email = user.email.toString();

    await FirebaseFirestore.instance
        .collection("UserCoins")
        .doc(email)
        .set(quizzesData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<Stream> getQuizData() async {
    return FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getCoinsData() async {
    var user = await getCurrentUser();

    return FirebaseFirestore.instance
        .collection("UserCoins")
        .doc(user.email.toString())
        .get();
  }

  getAvailableQuizzes() async {
    var user = await getCurrentUser();

    return FirebaseFirestore.instance
        .collection("UserAvailableQuizzes")
        .doc(user.email.toString())
        .get();
  }

  getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  getSpecificQuizData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QuestionAndAnswer")
        .get();
  }
}
