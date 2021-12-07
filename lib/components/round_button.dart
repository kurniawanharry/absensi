import 'package:flutter/material.dart';
import 'package:absensi/constants.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.titleButton, this.pressedButton, this.colorButton});
  final String titleButton;
  final Function pressedButton;
  final Color colorButton;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(200, 50),
          maximumSize: Size(200, 50),
          primary: colorButton),
      onPressed: pressedButton,
      child: Text(
        titleButton,
        style: kSendButtonTextStyle,
      ),
    );
  }
}
