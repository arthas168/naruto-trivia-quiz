import "package:flutter/material.dart";

Widget appBar(BuildContext context){
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: 22,
      ),
      children: <TextSpan>[
        TextSpan(text: 'Quiz', style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white)),
        TextSpan(text: 'Tsar 👑', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    ),
  );
}