import 'package:absensi/components/custom_painter.dart';
import 'package:flutter/material.dart';

class ListUserTile extends StatelessWidget {
  ListUserTile(
      {this.userName,
      this.checkTime,
      this.userLocation,
      this.userCheckInOrOut,
      this.userColor,
      this.gradientColor,
      this.absenImage});

  final String userName;
  final String checkTime;
  final String userLocation;
  final String userCheckInOrOut;
  final Color userColor;
  final List<Color> gradientColor;
  final String absenImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: gradientColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: userColor,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          top: 0,
          child: CustomPaint(
            size: Size(100, 0),
            painter: CanvasPhoto(),
          ),
        ),
        Positioned.fill(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(left: 3, top: 3, bottom: 3, right: 3),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(absenImage),
                      )),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          userName,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          checkTime,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Flexible(
                          child: Text(
                            userLocation,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  userCheckInOrOut,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
