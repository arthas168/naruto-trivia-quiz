import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';

class MaxedOutQuizzesProvider with ChangeNotifier {
  String _maxedOutQuizzes;
  DatabaseService databaseService = DatabaseService();

  MaxedOutQuizzesProvider() {
    _maxedOutQuizzes = "";
    load();
  }

  String get maxedOutQuizzes => _maxedOutQuizzes;

  // ignore: avoid_void_async
  void setMaxedOutQuizzes(String maxedOutQuizzes) async {
    _maxedOutQuizzes = maxedOutQuizzes;
    notifyListeners();

    final Map<String, String> maxedOutQuizzesMap = {
      "maxedOut": maxedOutQuizzes,
    };

    databaseService.addUserMaxedOutQuizzes(maxedOutQuizzesMap);
  }

  // ignore: type_annotate_public_apis, always_declare_return_types
  load() async {
    final res = await databaseService.getUserMaxedOutQuizzes();

    if (res.data() != null) {
      setMaxedOutQuizzes(res.data()["maxedOut"].toString());
    }
  }
}
