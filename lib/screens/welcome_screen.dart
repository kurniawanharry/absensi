import 'package:absensi/constants.dart';
import 'package:absensi/screens/login_screen.dart';
import 'package:absensi/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:absensi/components/round_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/';
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
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Image(
                  image: AssetImage(
                    'assets/logo.png',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(left: 80.0, right: 80.0),
              decoration: kContainerDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RoundedButton(
                    titleButton: 'Login',
                    colorButton: Color(0xFF2E4C6D),
                    pressedButton: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RoundedButton(
                    titleButton: 'Register',
                    colorButton: Color(0xFFFC997C),
                    pressedButton: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
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
