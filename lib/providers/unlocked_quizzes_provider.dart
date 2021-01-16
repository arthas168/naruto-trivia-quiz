import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';

class UnlockedQuizzesProvider with ChangeNotifier {
  int _numOfUnlockedQuizzes;
  DatabaseService databaseService = DatabaseService();

  UnlockedQuizzesProvider() {
    _numOfUnlockedQuizzes = 1;
    load();
  }

  int get numOfUnlockedQuizzes => _numOfUnlockedQuizzes;

  // ignore: avoid_void_async
  void setNumOfUnlockedQuizzes(int numOfUnlockedQuizzes) async {
    _numOfUnlockedQuizzes = numOfUnlockedQuizzes;
    notifyListeners();

    final Map<String, int> unlockedQuizzesMap = {
      "availableQuizzes": numOfUnlockedQuizzes,
    };

    databaseService.addAvailableQuizzes(unlockedQuizzesMap);
  }

  // ignore: type_annotate_public_apis, always_declare_return_types
  load() async {
    final res = await databaseService.getAvailableQuizzes();

    if (res.data() != null) {
      setNumOfUnlockedQuizzes(
          int.parse(res.data()["availableQuizzes"].toString()));
    }
  }
}
