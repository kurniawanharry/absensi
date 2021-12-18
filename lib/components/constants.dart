import 'package:flutter/material.dart';

const kColorMain = Color(0xFF2E4C6D);
const kColorMain2 = Color(0xFFFC997C);

const kSendButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  letterSpacing: 2.0,
  fontSize: 15.0,
);

const kTextStyle = TextStyle(
    color: Colors.white,
    letterSpacing: 2.0,
    fontSize: 40,
    fontFamily: 'BebasNeue');

const kContainerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(40.0),
    topRight: Radius.circular(40.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter Values',
  border: OutlineInputBorder(),
  isDense: true,
);

class GradientColors {
  static List<Color> checkIn = [Color(0xFF2FDD92), Color(0xFf34BE82)];
  static List<Color> checkOut = [Colors.pink, Colors.red];
}
