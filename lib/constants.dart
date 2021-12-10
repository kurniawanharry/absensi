import 'package:flutter/material.dart';

const kColorMain = Color(0xFF2E4C6D);

const kSendButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  letterSpacing: 2.0,
  fontSize: 15.0,
);

const kContainerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(40.0),
    topRight: Radius.circular(40.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter Values',
  //contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
  border: OutlineInputBorder(),
  isDense: true,
  //   borderRadius: BorderRadius.all(Radius.circular(20.0)),
  // ),
  // focusedBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Colors.lightBlueAccent),
  // ),
  // enabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Colors.lightBlueAccent),
  //   //borderRadius: BorderRadius.all(Radius.circular(20.0)),
  // ),
);

class GradientColors {
  static List<Color> checkIn = [Color(0xFF2FDD92), Color(0xFf34BE82)];
  static List<Color> checkOut = [Colors.pink, Colors.red];
}
