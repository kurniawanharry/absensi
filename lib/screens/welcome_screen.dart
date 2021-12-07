import 'package:absensi/constants.dart';
import 'package:flutter/material.dart';
import 'package:absensi/components/round_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E4C6D),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.all(100.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Logo',
                    style: kSendButtonTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: kContainerDecoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RoundedButton(
                    titleButton: 'Login',
                    colorButton: Color(0xFF2E4C6D),
                    pressedButton: () {},
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RoundedButton(
                    titleButton: 'Register',
                    colorButton: Color(0xFFFC997C),
                    pressedButton: () {},
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
