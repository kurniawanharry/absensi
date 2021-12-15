import 'package:absensi/components/round_textfield.dart';
import 'package:absensi/screens/home_screen.dart';
import 'package:absensi/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:absensi/constants.dart';
import 'package:absensi/components/round_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorMain,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 4,
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
          SingleChildScrollView(
            child: Container(
              decoration: kContainerDecoration,
              padding: EdgeInsets.only(
                  left: 60.0, right: 60.0, top: 100.0, bottom: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RoundTextField(
                    hintText: 'Masukan Email',
                    inputType: TextInputType.emailAddress,
                    iconButton: Icon(Icons.email),
                    outputValue: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RoundTextField(
                    hintText: 'Masukan Password',
                    secureText: true,
                    iconButton: Icon(Icons.lock),
                    outputValue: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RoundedButton(
                    titleButton: 'Login',
                    colorButton: kColorMain,
                    pressedButton: () async {
                      dynamic user = await _auth.loginUser(email, password);
                      if (user != null) {
                        Navigator.pushReplacementNamed(context, HomeScreen.id);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
