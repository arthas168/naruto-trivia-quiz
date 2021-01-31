import "package:flutter/material.dart";
import 'package:quizapp/helpers/constants.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: const TextSpan(
      style: TextStyle(
        fontSize: 22,
      ),
      children: <TextSpan>[
        TextSpan(
            text: 'Naruto',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: SECONDARY_COLOR)),
        TextSpan(
            text: ' Quiz',
            style:
                TextStyle(fontWeight: FontWeight.w300, color: SECONDARY_COLOR)),
      ],
    ),
  );
}
