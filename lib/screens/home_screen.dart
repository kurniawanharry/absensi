import 'package:absensi/components/constants.dart';
import 'package:absensi/models/task.dart';
import 'package:absensi/models/user.dart';
import 'package:absensi/screens/camera_page.dart';
import 'package:absensi/screens/welcome_screen.dart';
import 'package:absensi/services/auth.dart';
import 'package:absensi/services/database.dart';
import 'package:absensi/widgets/list_view_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "/home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = AuthService();
  bool isButton;
  bool exitSpinner = false;
  Position _currentPosition;
  String _currentAddress;
  String _currentAddressCountry;
  String _timeString;
  String _time;
  DateTime lastPressed = DateTime.now();
  String _timeDateQ;
  String _timeDate;

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
        if (mounted) {
          setState(() {
            _currentPosition = position;
            _getAddressFromLatLng();
          });
        }
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

      if (mounted) {
        setState(() {
          _currentAddress =
              "${place.locality}, ${place.postalCode}, ${place.country}";
          _currentAddressCountry = place.country;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _getTime() {
    final String formattedDateTime =
        DateFormat.yMEd().add_jm().format(DateTime.now()).toString();
    final String formattedTime =
        DateFormat.E().add_jm().format(DateTime.now()).toString();
    final String formattedDate =
        DateFormat.d().format(DateTime.now()).toString();

    if (mounted) {
      setState(() {
        _timeDate = formattedDate;
        _timeString = formattedDateTime;
        _time = formattedTime;
      });
    }
  }

  void _getDate() {
    final String formattedDate =
        DateFormat.d().format(DateTime.now()).toString();

    _timeDateQ = formattedDate;
  }

  _saveBool() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("check", isButton);
    await preferences.setString("date", _timeDateQ);
  }

  _loadBool() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        isButton = preferences.getBool("check");
        _timeDateQ = preferences.getString("date");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
    _getDate();
    _loadBool();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    _determinePosition();
    _getAddressFromLatLng();
    _getCurrentLocation();
    _getDate();
    _loadBool();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginUser = Provider.of<UserAbsen>(context);
    return loginUser == null
        ? Container(
            height: 100,
            width: 100,
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
                final now = DateTime.now();
                final maxDuration = Duration(seconds: 2);
                final isWarning = lastPressed == null ||
                    now.difference(lastPressed) > maxDuration;

                if (isWarning) {
                  lastPressed = DateTime.now();
                  const msg = 'Tekan sekali lagi untuk keluar';
                  Fluttertoast.showToast(msg: msg);
                  return false;
                } else {
                  await SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop');
                  return true;
                }
              },
              child: Scaffold(
                backgroundColor: kColorMain,
                floatingActionButton: SpeedDial(
                  buttonSize: 60,
                  backgroundColor: kColorMain2,
                  overlayOpacity: 0.2,
                  activeForegroundColor: Colors.black54,
                  animatedIcon: AnimatedIcons.add_event,
                  spaceBetweenChildren: 20,
                  childrenButtonSize: 70,
                  animatedIconTheme:
                      const IconThemeData(color: kColorMain, size: 30),
                  children: [
                    SpeedDialChild(
                      backgroundColor: Colors.green,
                      child:
                          FaIcon(FontAwesomeIcons.check, color: Colors.white),
                      label: 'Check In!',
                      visible: isButton == false ? true : false,
                      onTap: () async {
                        if (_timeDate == _timeDateQ) {
                          String imageAbsen = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CameraPage();
                              },
                            ),
                          );
                          if (imageAbsen == null) {
                            Container(child: CircularProgressIndicator());
                          } else {
                            DatabaseService(uid: loginUser.uid).addData(
                                _time,
                                _currentAddressCountry,
                                'Check In!',
                                imageAbsen);

                            setState(() {
                              final String formattedDate = DateFormat.d()
                                  .format(DateTime.now().add(Duration(days: 1)))
                                  .toString();
                              _timeDateQ = formattedDate;
                              isButton = true;
                              _saveBool();
                            });
                          }
                        } else {
                          setState(() {
                            // final String formattedDate = DateFormat.d()
                            //     .format(DateTime.now())
                            //     .toString();
                            // _timeDateQ = formattedDate;
                            // _saveBool();
                            Fluttertoast.showToast(
                                msg:
                                    'Hari ini tanggal ${_timeDate} sudah Check In! \n Check In akan aktif kembali pada tanggal ${_timeDateQ}!');
                          });
                        }
                      },
                    ),
                    SpeedDialChild(
                      backgroundColor: Colors.red,
                      child: FaIcon(FontAwesomeIcons.checkDouble,
                          color: Colors.white),
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
                        if (imageAbsen == null) {
                          Container(child: CircularProgressIndicator());
                        } else {
                          DatabaseService(uid: loginUser.uid).addData(_time,
                              _currentAddressCountry, 'Check Out!', imageAbsen);

                          setState(() {
                            isButton = false;
                            _saveBool();
                          });
                        }
                      },
                    ),
                  ],
                ),
                body: ModalProgressHUD(
                  inAsyncCall: exitSpinner,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            decoration: kContainerDecoration.copyWith(
                              color: kColorMain2,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            child: SafeArea(
                              child: Stack(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Positioned(
                                    top: 40,
                                    bottom: 40,
                                    left: 30,
                                    right: 190,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20),
                                      decoration: kContainerDecoration.copyWith(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                          bottomLeft: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Date Time',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                          Text(_timeString.toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 50,
                                    bottom: 50,
                                    left: 0,
                                    right: 290,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: kColorMain,
                                      ),
                                      child: Icon(
                                        Icons.access_time,
                                        color: kColorMain2,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    bottom: 40,
                                    left: 190,
                                    right: 10,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20),
                                      decoration: kContainerDecoration.copyWith(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                          bottomLeft: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                  ),
                                  Positioned(
                                    top: 50,
                                    bottom: 50,
                                    left: 160,
                                    right: 130,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        color: kColorMain,
                                      ),
                                      child: Icon(
                                        Icons.location_on,
                                        color: kColorMain2,
                                        size: 30,
                                      ),
                                    ),
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
                                  'Activity',
                                  style: kTextStyle.copyWith(fontSize: 30),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 2.0, right: 2.0),
                                    child: Divider(
                                      color: Colors.white,
                                      height: 2,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        primary: kColorMain2,
                                        onPrimary: kColorMain),
                                    onPressed: () {
                                      showDialog<String>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: kColorMain2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              title: Text(
                                                'Logout',
                                                style: kTextStyle.copyWith(
                                                  color: kColorMain,
                                                ),
                                              ),
                                              content: const Text(
                                                  'Are you sure you want to sign out ?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: kColorMain),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    if (mounted) {
                                                      setState(() {
                                                        exitSpinner = true;
                                                      });
                                                    }
                                                    await _auth.signOut();
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                            context,
                                                            WelcomeScreen.id,
                                                            (route) => false);
                                                    if (mounted) {
                                                      setState(() {
                                                        exitSpinner = false;
                                                      });
                                                    }
                                                  },
                                                  child: const Text('OK',
                                                      style: TextStyle(
                                                          color: kColorMain)),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: FaIcon(FontAwesomeIcons.signOutAlt),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 0.0, right: 20.0),
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
            ),
          );
  }
}
