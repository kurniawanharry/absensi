import 'package:absensi/components/round_textfield.dart';
import 'package:absensi/screens/home_screen.dart';
import 'package:absensi/screens/login_screen.dart';
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
  final _formKey = GlobalKey<FormState>();
  String username;
  String email;
  String password;
  String passwordConfirm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorMain,
      body: Center(
        child: LayoutBuilder(builder: (context, viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 10),
                            child: BackButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Center(
                          child: Image(
                            image: AssetImage(
                              'assets/logo.png',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: kContainerDecoration,
                    padding: EdgeInsets.only(
                        left: 60.0, right: 60.0, top: 50.0, bottom: 30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text('S I G N U P'),
                          SizedBox(
                            height: 20.0,
                          ),
                          RoundTextField(
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                            iconButton: Icon(Icons.email),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukan Email';
                              }
                              return null;
                            },
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
                            validator: (value) => value.length < 6
                                ? 'Password minimal 6 karakter'
                                : null,
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
                            validator: (value) {
                              if (value.length < 6) {
                                return 'Password minimal 6 karakter';
                              } else if (password != passwordConfirm) {
                                return 'Password Tidak Sama!';
                              }
                              return null;
                            },
                            outputValue: (value) {
                              passwordConfirm = value;
                            },
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          RoundedButton(
                            titleButton: 'SIGNUP',
                            colorButton: kColorMain2,
                            pressedButton: () async {
                              if (_formKey.currentState.validate()) {
                                final newUser =
                                    await _auth.registerUser(email, password);
                                if (newUser != null) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, HomeScreen.id, (route) => false);
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account ?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.id);
                                },
                                child: Text(
                                  'Log In',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
