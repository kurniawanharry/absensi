import 'package:absensi/components/constants.dart';
import 'package:absensi/models/task.dart';
import 'package:absensi/widgets/list_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListViewUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<List<Task>>(
      builder: (context, absen, child) {
        return absen == null
            ? Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
            : GridView.builder(
                reverse: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                });
      },
    );
  }
}
