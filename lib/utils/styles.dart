import 'package:flutter/material.dart';

const boldWhiteShadowFont = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 25,
  letterSpacing: 1.3,
  shadows: [
    Shadow(
      blurRadius: 4,
      color: Colors.black38,
      offset: Offset(2, 2),
    )
  ],
);

final darkBlueThinFont = TextStyle(
    fontWeight: FontWeight.w300, fontSize: 20, color: Colors.blueGrey.shade700);

const flatBlue = Color(0xFF61AAFF);
const flatOrange = Color(0xFFFFC672);
const flatGreen = Color(0xFF11CB72);
const flatRed = Color(0xFFF64747);

double getQuizSize(BuildContext context) {
  var media = MediaQuery.of(context);
  if (media.orientation == Orientation.portrait) {
    return MediaQuery.of(context).size.width * 0.65;
  } else {
    return MediaQuery.of(context).size.height * 0.6;
  }
}
