import 'package:flutter/material.dart';

import 'constants.dart';

class RoundTextField extends StatelessWidget {
  RoundTextField({
    this.hintText,
    this.inputType,
    this.outputValue,
    this.secureText = false,
    this.iconButton,
    this.validator,
  });
  final TextInputType inputType;
  final Function outputValue;
  final bool secureText;
  final String hintText;
  final Widget iconButton;
  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: secureText,
      onChanged: outputValue,
      validator: validator,
      style: TextStyle(
        color: Colors.black54,
      ),
      decoration: kTextFieldDecoration.copyWith(
        hintText: hintText,
        prefixIcon: iconButton,
      ),
    );
  }
}
