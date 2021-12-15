import 'package:absensi/models/user.dart';
import 'package:absensi/screens/home_screen.dart';
import 'package:absensi/screens/login_screen.dart';
import 'package:absensi/screens/registration_screen.dart';
import 'package:absensi/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Absen());
}

class Absen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserAbsen>.value(
          value: AuthService().user,
        ),
      ],
      child: MaterialApp(
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? WelcomeScreen.id
            : HomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          HomeScreen.id: (context) => HomeScreen(),
        },
      ),
    );
  }
}
