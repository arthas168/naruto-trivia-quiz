import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/helper/constants.dart';
import 'package:quizapp/views/user_menu.dart';
import 'package:quizapp/widgets/widgets.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: appBar(context),
          actions: [
            UserMenuActions(),
          ],
          centerTitle: true,
          backgroundColor: MAIN_COLOR,
          elevation: 0,
          brightness: Brightness.light),
      body: Container(),
    );
  }
}
