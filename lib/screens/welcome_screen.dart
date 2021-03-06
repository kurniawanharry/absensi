import 'package:absensi/components/constants.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E4C6D),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(
                      'assets/logo.png',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.only(left: 60.0, right: 60.0),
              decoration: kContainerDecoration,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                overflow: Overflow.visible,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Positioned(
                    top: -25,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: kContainerDecoration.copyWith(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 1.0,
                              offset: Offset(0.0, 0.75))
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Absensi',
                          style: kTextStyle.copyWith(
                              color: Colors.black54, fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    left: 40,
                    child: Container(
                      child: RoundedButton(
                        titleButton: 'LOGIN',
                        colorButton: kColorMain,
                        pressedButton: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginScreen.id, (route) => false);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: EdgeInsets.only(left: 20.0, right: 2.0),
                            child: Divider(
                              color: Colors.black54,
                              height: 2,
                            ),
                          ),
                        ),
                        Text(
                          'OR',
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: EdgeInsets.only(left: 2.0, right: 20.0),
                            child: Divider(
                              color: Colors.black54,
                              height: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Positioned(
                    top: 160,
                    left: 40,
                    child: Container(
                      child: RoundedButton(
                        titleButton: 'SIGNUP',
                        colorButton: kColorMain2,
                        pressedButton: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, RegistrationScreen.id, (route) => false);
                        },
                      ),
                    ),
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
