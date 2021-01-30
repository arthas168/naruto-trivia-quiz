import 'package:flutter/material.dart';
import 'package:quizapp/services/database.dart';

class CoinsProvider with ChangeNotifier {
  String _coins;
  DatabaseService databaseService = DatabaseService();

  CoinsProvider() {
    _coins = "5";
    load();
  }

  String get coins => _coins;

  void setCoins(String coins) {
    _coins = coins;
    notifyListeners();
  }

  // ignore: type_annotate_public_apis, always_declare_return_types
  load() async {
    final res = await databaseService.getCoinsData();

    if (res.data() != null) {
      setCoins(res.data()["coins"].toString());
    }
  }
}
