import 'package:absensi/components/constants.dart';
import 'package:absensi/components/menu_button.dart';
import 'package:absensi/models/task.dart';
import 'package:absensi/models/user.dart';
import 'package:absensi/screens/history_screen.dart';
import 'package:absensi/screens/welcome_screen.dart';
import 'package:absensi/services/auth.dart';
import 'package:absensi/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'camera_page.dart';

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
  String docId;
  String check;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    _loadBool();
  }

  @override
  void dispose() {
    _determinePosition();
    _getAddressFromLatLng();
    _getCurrentLocation();
    _loadBool();
    super.dispose();
  }

  //TODO Ubah Ui

  @override
  Widget build(BuildContext context) {
    final CollectionReference absen =
        FirebaseFirestore.instance.collection('absensi');
    final loginUser = Provider.of<UserAbsen>(context);
    return loginUser == null || _timeDateQ == null
        ? Container(
            alignment: Alignment.center,
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
                body: ModalProgressHUD(
                  inAsyncCall: exitSpinner,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Stack(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 30,
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                decoration: kContainerDecoration.copyWith(
                                  color: kColorMain2,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Presensi',
                                        style:
                                            kTextStyle.copyWith(fontSize: 30)),
                                    PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: kColorMain,
                                        ),
                                        color: kColorMain3,
                                        onSelected: onSelect,
                                        itemBuilder: (BuildContext context) {
                                          return myMenuItems
                                              .map((String choice) {
                                            return PopupMenuItem<String>(
                                              child: Text(choice),
                                              value: choice,
                                            );
                                          }).toList();
                                        })
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 90,
                              bottom: 10,
                              left: 20,
                              right: 20,
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                decoration: kContainerDecoration.copyWith(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 2.0,
                                        offset: Offset(0.0, 0.1))
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image(
                                              fit: BoxFit.fill,
                                              image:
                                                  AssetImage('assets/jun.jpg')),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Jun Naruse',
                                              style: kTextStyle.copyWith(
                                                  fontSize: 20,
                                                  color: kColorMain4),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                            padding:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: MenuButton(
                                    midIcon: Icon(MdiIcons.loginVariant),
                                    textButton: 'Presensi\nDatang',
                                    pressedButton: isButton
                                        ? null
                                        : () async {
                                            if (_timeDate == _timeDateQ) {
                                              if (_timeDate != '32') {
                                                check = 'Check';
                                              }

                                              docId = await absen
                                                  .doc(loginUser.uid)
                                                  .collection('check')
                                                  .doc()
                                                  .id;
                                              String imageAbsen =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return CameraPage();
                                                  },
                                                ),
                                              );
                                              if (imageAbsen == null &&
                                                  docId == null) {
                                                Container(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else {
                                                DatabaseService(
                                                        uid: loginUser.uid,
                                                        docId: docId)
                                                    .addData(
                                                        _time,
                                                        _currentAddressCountry,
                                                        check,
                                                        imageAbsen);

                                                setState(() {
                                                  final String formattedDate =
                                                      DateFormat.d()
                                                          .format(
                                                            DateTime.now().add(
                                                              const Duration(
                                                                days: 1,
                                                              ),
                                                            ),
                                                          )
                                                          .toString();
                                                  _timeDateQ = formattedDate;
                                                  isButton = true;
                                                  _saveBool();
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                final String formattedDate =
                                                    DateFormat.d()
                                                        .format(DateTime.now())
                                                        .toString();
                                                _timeDateQ = formattedDate;
                                                _saveBool();
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Hari ini tanggal ${_timeDate} sudah Check In!\nCheck In akan aktif kembali pada tanggal ${_timeDateQ}!');
                                              });
                                            }
                                          },
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: MenuButton(
                                    midIcon: Icon(MdiIcons.logoutVariant),
                                    textButton: 'Presensi\nPulang',
                                    pressedButton: isButton
                                        ? () async {
                                            if (_timeDate != '32') {
                                              check = 'Check Out';
                                            }

                                            String imageAbsen =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return CameraPage();
                                                },
                                              ),
                                            );
                                            if (imageAbsen == null) {
                                              // ignore: avoid_unnecessary_containers
                                              Container(
                                                  child:
                                                      const CircularProgressIndicator());
                                            } else {
                                              DatabaseService(
                                                      uid: loginUser.uid,
                                                      docId: docId)
                                                  .updateData(
                                                      _time,
                                                      _currentAddressCountry,
                                                      check,
                                                      imageAbsen);

                                              setState(() {
                                                isButton = false;
                                                _saveBool();
                                              });
                                            }
                                          }
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: MenuButton(
                                    midIcon: Icon(MdiIcons.history),
                                    textButton: 'Histori\nPresensi',
                                    pressedButton: () {
                                      Navigator.pushNamed(context, History.id);
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('waktu')
                              .doc('waktu')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text("Loading");
                            }
                            var userDocument = snapshot.data;
                            return Expanded(
                              flex: 4,
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Jadwal Presensi',
                                                style: kTextStyle.copyWith(
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Regular - ${_timeString.toString()}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                        color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 60,
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            decoration:
                                                kContainerDecoration.copyWith(
                                              color: kColorMain3,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    child: const FaIcon(
                                                      FontAwesomeIcons
                                                          .signInAlt,
                                                      color: kColorMain2,
                                                    ),
                                                  ),
                                                ),
                                                const Expanded(
                                                  flex: 3,
                                                  child: Text('Jam Datang',
                                                      style: TextStyle(
                                                          color: kColorMain2,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: kColorMain2,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            blurRadius: 0.2)
                                                      ],
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                          userDocument[
                                                              'jamDatang'],
                                                          style: kTextStyle
                                                              .copyWith(
                                                                  fontSize:
                                                                      20)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            height: 60,
                                            padding: EdgeInsets.only(
                                              right: 20,
                                            ),
                                            decoration:
                                                kContainerDecoration.copyWith(
                                              color: kColorMain3,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    child: const FaIcon(
                                                      FontAwesomeIcons
                                                          .signOutAlt,
                                                      color: kColorMain2,
                                                    ),
                                                  ),
                                                ),
                                                const Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    'Jam Pulang',
                                                    style: TextStyle(
                                                        color: kColorMain2,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: kColorMain2,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            blurRadius: 0.2)
                                                      ],
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        userDocument[
                                                            'jamPulang'],
                                                        style:
                                                            kTextStyle.copyWith(
                                                                fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  // Method

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
        DateFormat('dd MMMM yyyy').format(DateTime.now()).toString();
    final String formattedTime =
        DateFormat.Hm().format(DateTime.now()).toString();
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

  _saveBool() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("check", isButton);
    await preferences.setString("date", _timeDateQ);
    await preferences.setString("documentid", docId);
  }

  _loadBool() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        isButton = preferences.getBool("check") ?? false;
        docId = preferences.getString("documentid") ?? 'PRESENSI123';
        _timeDateQ = preferences.getString("date") ??
            DateFormat.d().format(DateTime.now()).toString();
      });
    }
  }

  var myMenuItems = <String>[
    'Home',
    'Setting',
    'Logout',
  ];

  void onSelect(item) {
    switch (item) {
      case 'Home':
        print('Home clicked');
        break;
      case 'Setting':
        print('Profile clicked');
        break;
      case 'Logout':
        if (mounted) {
          setState(() {
            showDialog<String>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: kColorMain2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Logout',
                      style: kTextStyle.copyWith(
                        color: kColorMain,
                      ),
                    ),
                    content: const Text(
                      'Are you sure you want to sign out ?',
                      style: TextStyle(color: kColorMain),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: kColorMain),
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
                          Navigator.pushNamedAndRemoveUntil(
                              context, WelcomeScreen.id, (route) => false);
                          if (mounted) {
                            setState(() {
                              exitSpinner = false;
                            });
                          }
                        },
                        child: const Text('OK',
                            style: TextStyle(color: kColorMain)),
                      ),
                    ],
                  );
                });
          });
          break;
        }
    }
  }
}
