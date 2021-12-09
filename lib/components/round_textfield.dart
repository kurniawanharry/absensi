import 'package:flutter/material.dart';

import '../constants.dart';

class RoundTextField extends StatelessWidget {
  RoundTextField(
      {this.hintText,
      this.inputType,
      this.outputValue,
      this.secureText = false});
  final TextInputType inputType;
  final Function outputValue;
  final bool secureText;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: inputType,
      obscureText: secureText,
      onChanged: outputValue,
      style: TextStyle(
        color: Colors.black54,
      ),
      decoration: kTextFieldDecoration.copyWith(
        hintText: hintText,
      ),
    );
  }
}