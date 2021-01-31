import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future<void> addQuizSeasonTwoData(
      Map<String, dynamic> quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("QuizSeasonTwo")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future<void> addQuestionSeasonTwoData(
      Map<String, dynamic> questionData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("QuizSeasonTwo")
        .doc(quizId)
        .collection("QuestionAndAnswer")
        .add(questionData)
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future<void> addQuestionData(
      Map<String, dynamic> questionData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QuestionAndAnswer")
        .add(questionData)
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future<void> addUserCoins(
      Map<String, String> coinsData, String userEmail) async {
    await FirebaseFirestore.instance
        .collection("UserCoins")
        .doc(userEmail)
        .set(coinsData)
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future<void> addAvailableQuizzes(Map<String, int> quizzesData) async {
    final user = await getCurrentUser();
    final email = user.email.toString();

    await FirebaseFirestore.instance
        .collection("UserAvailableQuizzes")
        .doc(email)
        .set(quizzesData)
        .catchError((e) {
      // ignore: avoid_print
      print(e.toString());
    });
  }

  Future<Stream> getQuizData() async {
    return FirebaseFirestore.instance
        .collection("Quiz")
        .orderBy("date")
        .snapshots();
  }

  Future<Stream> getQuizSeasonTwoData() async {
    return FirebaseFirestore.instance
        .collection("QuizSeasonTwo")
        .orderBy("date")
        .snapshots();
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  getCoinsData() async {
    final user = await getCurrentUser();

    return FirebaseFirestore.instance
        .collection("UserCoins")
        .doc(user.email.toString())
        .get();
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  getAvailableQuizzes() async {
    final user = await getCurrentUser();

    return FirebaseFirestore.instance
        .collection("UserAvailableQuizzes")
        .doc(user.email.toString())
        .get();
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  getSpecificQuizData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QuestionAndAnswer")
        .orderBy("date")
        .get();
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  getSpecificQuizSeasonTwoData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("QuizSeasonTwo")
        .doc(quizId)
        .collection("QuestionAndAnswer")
        .orderBy("date")
        .get();
  }
}
