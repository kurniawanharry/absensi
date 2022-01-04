import 'package:flutter/material.dart';

const kColorMain = Color(0xFFFFFFFF);
const kColorMain2 = Color(0xFF6b019f);
const kColorMain3 = Color(0xFFebdfed);
const kColorMain4 = Color(0xFF141314);
const kColorMain5 = Color(0x50141314);

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
    fontFamily: 'SpoqaHanSansNeo');

const kContainerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(40.0),
    topRight: Radius.circular(40.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter Values',
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kColorMain2),
  ),
  border: OutlineInputBorder(),
  isDense: true,
);

class GradientColors {
  static List<Color> checkIn = [Color(0xFF2FDD92), Color(0xFf34BE82)];
  static List<Color> checkOut = [Colors.pink, Colors.red];
}
