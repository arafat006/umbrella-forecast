import 'package:flutter/material.dart';
import 'package:umbrella/constant/constant.dart';

class ResultButton extends StatelessWidget {
  const ResultButton({Key? key, required this.onPress}) : super(key: key);

  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPress();
      },
      child: const Text(
        'Umbrella',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w500,
          fontFamily: 'PTSerif',
          letterSpacing: 2,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: kCardButtonColor, // set the background color
        // Color onPrimary,
        // Color onSurface,
        // Color shadowColor,
        // double elevation,
        // TextStyle textStyle,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        // Size minimumSize,
        // BorderSide side,
        // OutlinedBorder shape,
        // MouseCursor enabledMouseCursor,
        // MouseCursor disabledMouseCursor,
        // VisualDensity visualDensity,
        // MaterialTapTargetSize tapTargetSize,
        // Duration animationDuration,
        // bool enableFeedback
      ),
    );
  }
}
