import 'package:absensi/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorMain,
      child: Center(
        child: SpinKitChasingDots(
          color: kColorMain2,
          size: 50.0,
        ),
      ),
    );
  }
}
