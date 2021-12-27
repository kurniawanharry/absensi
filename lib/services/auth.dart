import 'package:absensi/models/user.dart';
import 'package:absensi/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create User Object based on FirebaseUser
  UserAbsen _userFromFirebaseUser(User user) {
    return user != null ? UserAbsen(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<UserAbsen> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //Register with Email and Password
  Future registerUser(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await DatabaseService(uid: user.uid).updateUserData(user.email);
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        const msg = 'The password provided is too weak.';
        Fluttertoast.showToast(msg: msg);
      } else if (e.code == 'email-already-in-use') {
        const msg = 'The account already exists for that email.';
        Fluttertoast.showToast(msg: msg);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Signin with Email and Password
  Future loginUser(String email, String password) async {
    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = _authResult.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        const msg = 'No user found for that email.';
        Fluttertoast.showToast(msg: msg);
      } else if (e.code == 'wrong-password') {
        const msg = 'Wrong password provided for that user.';
        Fluttertoast.showToast(msg: msg);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
