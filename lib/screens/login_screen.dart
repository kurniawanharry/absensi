import 'package:absensi/components/round_textfield.dart';
import 'package:absensi/screens/home_screen.dart';
import 'package:absensi/screens/registration_screen.dart';
import 'package:absensi/screens/welcome_screen.dart';
import 'package:absensi/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:absensi/components/constants.dart';
import 'package:absensi/components/round_button.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  DateTime lastPressed;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorMain,
      body: WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          final maxDuration = Duration(seconds: 3);
          final isWarning =
              lastPressed == null || now.difference(lastPressed) > maxDuration;

          if (isWarning) {
            lastPressed = DateTime.now();
            const msg = 'Tekan sekali lagi untuk keluar';
            Fluttertoast.showToast(msg: msg);
            return false;
          } else {
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          }
        },
        child: Center(
          child: LayoutBuilder(builder: (context, viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, left: 10),
                          child: BackButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, WelcomeScreen.id);
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Container(
                          child: Image(
                            image: AssetImage(
                              'assets/logo.png',
                            ),
                          ),
                        ),
                      ),
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
                            Text('L O G I N'),
                            SizedBox(
                              height: 20.0,
                            ),
                            RoundTextField(
                              hintText: 'Masukan Email',
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
                              hintText: 'Masukan Password',
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
                              height: 20.0,
                            ),
                            RoundedButton(
                              titleButton: 'LOGIN',
                              colorButton: kColorMain,
                              pressedButton: () async {
                                if (_formKey.currentState.validate()) {
                                  final user =
                                      await _auth.loginUser(email, password);
                                  if (user != null) {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        HomeScreen.id, (route) => false);
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
                                Text('Don\'t have an account yet ?'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, RegistrationScreen.id);
                                  },
                                  child: Text(
                                    'Sign Up',
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
      ),
    );
  }
}
