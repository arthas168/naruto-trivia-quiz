import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  // todo: maybe extract as constant
  // ignore: constant_identifier_names
  static const String USER_LOGGED_IN_KEY = "NOT_LOGGED_IN";

  // ignore: type_annotate_public_apis, always_declare_return_types
  static saveLoggedUserDetails({@required bool isLoggedIn}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(USER_LOGGED_IN_KEY, isLoggedIn);
  }

  static Future<bool> getLoggedUserDetails() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(USER_LOGGED_IN_KEY);
  }
}
