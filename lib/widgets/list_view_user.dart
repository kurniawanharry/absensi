import 'package:absensi/components/constants.dart';
import 'package:absensi/models/task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'list_user_tile.dart';

class ListViewUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<List<Task>>(
      builder: (context, absen, child) {
        return absen == null
            ? Container(
                alignment: Alignment.center,
                child: Text(
                  'Loading. . .',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: absen.length,
                itemBuilder: (context, index) {
                  final task = absen[index];
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListUserTile(
                        userName: 'Username',
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
                });
      },
    );
  }
}
