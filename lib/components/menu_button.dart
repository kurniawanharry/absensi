import 'package:absensi/components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MenuButton extends StatelessWidget {
  MenuButton({this.midIcon, this.textButton = '', this.pressedButton});

  final String textButton;
  final Icon midIcon;
  final Function pressedButton;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 80),
                  maximumSize: const Size(80, 80),
                  primary: kColorMain3,
                  onPrimary: kColorMain2),
              child: midIcon,
              onPressed: pressedButton),
          const SizedBox(
            height: 20,
          ),
          Text(
            textButton,
            textAlign: TextAlign.center,
            style: kTextStyle.copyWith(fontSize: 15, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
