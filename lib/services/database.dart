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

  Future<Stream> getQuizData() async {
    return FirebaseFirestore.instance.collection("Quiz").snapshots();
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
