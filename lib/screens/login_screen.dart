import 'package:absensi/components/round_textfield.dart';
import 'package:absensi/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:absensi/constants.dart';
import 'package:absensi/components/round_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E4C6D),
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
                    outputValue: (value) {},
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RoundTextField(
                    hintText: 'Masukan Password',
                    secureText: true,
                    iconButton: Icon(Icons.lock),
                    outputValue: (value) {},
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RoundedButton(
                    titleButton: 'Login',
                    colorButton: Color(0xFF2E4C6D),
                    pressedButton: () {
                      Navigator.pushNamed(context, HomeScreen.id);
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
