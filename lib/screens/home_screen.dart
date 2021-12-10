import 'package:absensi/components/round_button.dart';
import 'package:absensi/components/round_textfield.dart';
import 'package:absensi/constants.dart';
import 'package:absensi/widgets/camera_page.dart';
import 'package:absensi/widgets/list_view_user.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
      floatingActionButton: SpeedDial(
        overlayOpacity: 0.2,
        activeForegroundColor: Colors.black54,
        animatedIcon: AnimatedIcons.menu_close,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
              label: 'Check In!',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CameraPage()));
              }),
          SpeedDialChild(
            backgroundColor: Colors.red,
            child: Icon(Icons.exit_to_app, color: Colors.white),
            label: 'Check Out!',
          ),
        ],
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
