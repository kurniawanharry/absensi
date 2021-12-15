import 'package:absensi/constants.dart';
import 'package:absensi/models/task.dart';
import 'package:absensi/models/user.dart';
import 'package:absensi/screens/camera_page.dart';
import 'package:absensi/services/auth.dart';
import 'package:absensi/services/database.dart';
import 'package:absensi/widgets/list_view_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "/home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = AuthService();
  bool isButton;
  Position _currentPosition;
  String _currentAddress;
  String _timeString;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await _getCurrentLocation();
  }

  _getCurrentLocation() async {
    try {
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).then((Position position) {
        setState(() {
          _currentPosition = position;
          _getAddressFromLatLng();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  void _getTime() {
    final String formattedDateTime =
        DateFormat.yMEd().add_jm().format(DateTime.now()).toString();

    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  _saveBool() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("check", isButton);
  }

  _loadBool() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        isButton = preferences.getBool("check");
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
    _loadBool();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    _determinePosition();
    _loadBool();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginUser = Provider.of<UserAbsen>(context);
    return loginUser == null
        ? Container(
            child: const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          )
        : StreamProvider<List<Task>>.value(
            value: DatabaseService(uid: loginUser.uid).absenUser,
            child: WillPopScope(
              onWillPop: () async {
                //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                return true;
              },
              child: Scaffold(
                backgroundColor: kColorMain,
                floatingActionButton: SpeedDial(
                  buttonSize: 60,
                  backgroundColor: Colors.white,
                  overlayOpacity: 0.2,
                  activeForegroundColor: Colors.black54,
                  animatedIcon: AnimatedIcons.menu_close,
                  spaceBetweenChildren: 20,
                  childrenButtonSize: 60,
                  animatedIconTheme:
                      const IconThemeData(color: kColorMain, size: 30),
                  children: [
                    SpeedDialChild(
                        backgroundColor: Colors.green,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        label: 'Check In!',
                        visible: isButton == true ? false : true,
                        onTap: () async {
                          String imageAbsen = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CameraPage();
                              },
                            ),
                          );
                          imageAbsen == null
                              ? Container(
                                  child: CircularProgressIndicator(),
                                )
                              : DatabaseService(uid: loginUser.uid).addData(
                                  _timeString,
                                  _currentAddress,
                                  'Check In!',
                                  imageAbsen);

                          setState(() {
                            isButton = true;
                            _saveBool();
                          });
                        }),
                    SpeedDialChild(
                      backgroundColor: Colors.red,
                      child: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      label: 'Check Out!',
                      visible: isButton == true ? true : false,
                      onTap: () async {
                        String imageAbsen = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CameraPage();
                            },
                          ),
                        );
                        imageAbsen == null
                            ? Container(
                                child: CircularProgressIndicator(),
                              )
                            : DatabaseService(uid: loginUser.uid).addData(
                                _timeString,
                                _currentAddress,
                                'Check Out!',
                                imageAbsen);

                        setState(() {
                          isButton = false;
                          _saveBool();
                        });
                      },
                    ),
                    SpeedDialChild(
                      backgroundColor: Colors.black,
                      child: const Icon(
                        Icons.door_back_door,
                        color: Colors.white,
                      ),
                      label: 'Logout',
                      onTap: () async {
                        await _auth.signOut();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          decoration: kContainerDecoration.copyWith(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0),
                              bottomLeft: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                            ),
                          ),
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      color: kColorMain,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Date Time',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                            Text(_timeString.toString()),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      color: kColorMain,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Location',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                          if (_currentPosition != null &&
                                              _currentAddress != null)
                                            Text(_currentAddress,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: 20.0, right: 2.0),
                                  child: Divider(
                                    color: Colors.white,
                                    height: 2,
                                  ),
                                ),
                              ),
                              Text(
                                'History',
                                style: kSendButtonTextStyle,
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: 2.0, right: 20.0),
                                  child: Divider(
                                    color: Colors.white,
                                    height: 2,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: ListViewUser(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
