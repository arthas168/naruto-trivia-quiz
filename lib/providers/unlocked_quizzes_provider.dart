import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';

class UnlockedQuizzesProvider with ChangeNotifier {
  int _numOfUnlockedQuizzes;
  DatabaseService databaseService = new DatabaseService();

  UnlockedQuizzesProvider() {
    _numOfUnlockedQuizzes = 1;
    load();
  }

  int get numOfUnlockedQuizzes => _numOfUnlockedQuizzes;

  void setNumOfUnlockedQuizzes(int numOfUnlockedQuizzes) async {
    _numOfUnlockedQuizzes = numOfUnlockedQuizzes;
    notifyListeners();

    Map<String, int> unlockedQuizzesMap = {
      "availableQuizzes": numOfUnlockedQuizzes,
    };

    databaseService.addAvailableQuizzes(unlockedQuizzesMap);
  }

  load() async {
    var res = await databaseService.getAvailableQuizzes();

    if (res.data() != null) {
      setNumOfUnlockedQuizzes(
          int.parse(res.data()["availableQuizzes"].toString()));
    }
  }
}
