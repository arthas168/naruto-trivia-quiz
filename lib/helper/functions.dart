import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {

  static const String USER_LOGGED_IN_KEY = "asdf";

  static saveLoggedUserDetails({@required bool isLoggedIn}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(USER_LOGGED_IN_KEY, isLoggedIn);
  }

  static Future<bool> getLoggedUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(USER_LOGGED_IN_KEY);
  }
}