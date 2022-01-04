import 'package:absensi/components/constants.dart';
import 'package:absensi/components/custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListUserTile extends StatelessWidget {
  ListUserTile(
      {this.checkTime,
      this.userLocation,
      this.userCheckIn,
      this.checkTimeOut,
      this.userLocationOut,
      this.userCheckOut
      // this.absenImage
      });

  final String checkTime;
  final String userLocation;
  final String userCheckIn;
  // final String absenImage;
  final String checkTimeOut;
  final String userLocationOut;
  final String userCheckOut;
  // final String absenImageOut;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kColorMain,
            boxShadow: [
              BoxShadow(
                color: kColorMain2,
                blurRadius: 4,
                offset: Offset(0, 0.2),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Row(
            children: [
              Container(
                width: 15,
                decoration: kContainerDecoration.copyWith(
                  color: kColorMain2,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                // Menjadi Waktu untuk sementara
                                userLocation,
                                style: kTextStyle.copyWith(
                                    fontSize: 15, color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Waktu Presensi',
                                    style: kTextStyle.copyWith(
                                        fontSize: 19, color: kColorMain2),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    checkTime,
                                    style: kTextStyle.copyWith(
                                        fontSize: 20, color: kColorMain4),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    userCheckIn,
                                    style: kTextStyle.copyWith(
                                        fontSize: 15, color: kColorMain5),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(
                                        bottom: 50, left: 10),
                                    child: const FaIcon(
                                      FontAwesomeIcons.minus,
                                      size: 20,
                                      color: kColorMain2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Waktu Pulang',
                                    style: kTextStyle.copyWith(
                                        fontSize: 19, color: kColorMain2),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    checkTimeOut,
                                    style: kTextStyle.copyWith(
                                        fontSize: 20, color: kColorMain4),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    userCheckOut,
                                    style: kTextStyle.copyWith(
                                        fontSize: 15, color: kColorMain5),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
