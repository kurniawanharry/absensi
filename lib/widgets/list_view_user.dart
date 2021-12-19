import 'dart:async';

import 'package:absensi/components/constants.dart';
import 'package:absensi/models/task.dart';
import 'package:absensi/widgets/list_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListViewUser extends StatefulWidget {
  @override
  State<ListViewUser> createState() => _ListViewUserState();
}

class _ListViewUserState extends State<ListViewUser> {
  int _counter;
  Timer _timer;

  void _startTime() {
    _counter = 3;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_counter > 0) {
            _counter--;
          } else {
            _timer.cancel();
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _startTime();
    super.initState();
  }

  @override
  void dispose() {
    _startTime();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<List<Task>>(
      builder: (context, absen, child) {
        return absen == null || absen.isEmpty
            ? Container(
                alignment: Alignment.center,
                child: (_counter > 0)
                    ? CircularProgressIndicator()
                    : Text('No Activity',
                        style: kTextStyle.copyWith(
                            fontSize: 20, color: Colors.white30)))
            : Align(
                alignment: Alignment.topCenter,
                child: GridView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 1.7,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2),
                    cacheExtent: 9999,
                    itemCount: absen.length,
                    itemBuilder: (context, index) {
                      final task = absen[index];
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(1.0),
                          child: ListUserTile(
                            checkTime: task.userTime,
                            userLocation: task.userLocation,
                            userCheckInOrOut: task.userCheck,
                            userColor: task.userCheck == 'Check In!'
                                ? Colors.green
                                : Colors.red,
                            gradientColor: task.userCheck == 'Check In!'
                                ? GradientColors.checkIn
                                : GradientColors.checkOut,
                            absenImage: task.userImage,
                          ),
                        ),
                      );
                    }),
              );
      },
    );
  }
}
