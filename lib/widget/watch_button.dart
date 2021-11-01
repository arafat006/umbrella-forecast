import 'package:flutter/material.dart';
import 'package:umbrella/constant/constant.dart';

class WatchButton extends StatelessWidget {
  const WatchButton({Key? key, required this.icon, required this.onPress})
      : super(key: key);

  final IconData icon;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        icon,
        size: 25.0,
      ),
      // elevation: 6.0,
      constraints: const BoxConstraints.tightFor(
          width: kWatchButtonWidth, height: kWatchButtonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      fillColor: const Color(0xff1F618D), //1F618D  2980B9
      onPressed: () {
        onPress();
      },
    );
  }
}
