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
