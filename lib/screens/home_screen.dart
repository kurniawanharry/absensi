import 'package:absensi/components/round_button.dart';
import 'package:absensi/components/round_textfield.dart';
import 'package:absensi/constants.dart';
import 'package:absensi/widgets/list_view_user.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "/home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorMain,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add_a_photo,
          color: Colors.black54,
        ),
        onPressed: () {},
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              decoration: kContainerDecoration.copyWith(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'Logo',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                child: Text(
                  'History',
                  style: kSendButtonTextStyle,
                )),
          ),
          Expanded(
            flex: 6,
            child: Container(
              //padding: EdgeInsets.all(10),
              child: ListViewUser(),
            ),
          ),
        ],
      ),
    );
  }
}
