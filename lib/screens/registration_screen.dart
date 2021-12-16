import 'package:absensi/components/round_textfield.dart';
import 'package:absensi/screens/home_screen.dart';
import 'package:absensi/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:absensi/components/constants.dart';
import 'package:absensi/components/round_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = '/registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = AuthService();
  String username;
  String email;
  String password;
  String passwordConfirm;
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
                  left: 60.0, right: 60.0, top: 50.0, bottom: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('S I G N U P'),
                  SizedBox(
                    height: 20.0,
                  ),
                  RoundTextField(
                    hintText: 'Username',
                    inputType: TextInputType.emailAddress,
                    iconButton: Icon(Icons.account_circle),
                    outputValue: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RoundTextField(
                    hintText: 'Email',
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
                    hintText: 'Password',
                    secureText: true,
                    iconButton: Icon(Icons.lock),
                    outputValue: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RoundTextField(
                    hintText: 'Confirm Password',
                    secureText: true,
                    iconButton: Icon(Icons.lock_rounded),
                    outputValue: (value) {
                      passwordConfirm = value;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RoundedButton(
                    titleButton: 'SIGNUP',
                    colorButton: kColorMain2,
                    pressedButton: () async {
                      if (password == passwordConfirm) {
                        final newUser =
                            await _auth.registerUser(email, password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, HomeScreen.id);
                        }
                      } else {
                        Fluttertoast.showToast(msg: 'Password Tidak Sama');
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('Already have an account ? L O G I N')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
