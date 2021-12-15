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
        Positioned.fill(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: absenImage == null
                    ? Image.network(
                        'https://i.pinimg.com/736x/2b/e5/6b/2be56b052e9a4b15ab987d43eba3bbd2.jpg')
                    : Image.network(
                        'https://i.pinimg.com/736x/2b/e5/6b/2be56b052e9a4b15ab987d43eba3bbd2.jpg',
                        width: 50,
                        height: 50,
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
