import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color kInActiveColor = Color(0xffDF354A);
const Color kActiveColor = Color(0xff358BC5); //1EDE5E //00C977 //2D89C7
const Color kEmptyColor = Color(0xff555555); //1EDE5E //00C977 //2D89C7

//card constant...
const FontWeight kCardTopTextFontWeight = FontWeight.w300;
const FontWeight kCardBottomTextFontWeight = FontWeight.w600;
const double kCardTopTextFontSize = 20;
const double kCardBottomTextFontSize = 20;
const Color kCardBackColor = Color(0xff11052B);
const Color kCardButtonColor = Color(0xff1F618D);
// const Color kCardBackColor = Color(0xff061C30);
const Color kCardBorderColor = Color(0xff3A4147); //10406B 051523

//watch constant...
const Color kDialBackColor = Color(0xff555555); //1E053D
const Color kButtonBackColor = Color(0xff1F618D);
const double kWatchFontSize = 40.0;
const double kWatchButtonHeight = 30.0;
const double kWatchButtonWidth = 90.0;

// const Color kScaffoldBackColor = Color(0xff072B4B);
const Color kScaffoldBackColor = Color(0xff00294E); //05192B

//Umbrella path constant...
const String defaultImgPath = 'assets/image/default_umbrella.png';
const String rainingImgPath = 'assets/image/yesRain.gif';
const String mayRainingImgPath = 'assets/image/mayRain.gif';
const String notRainingImgPath = 'assets/image/noRain.png';

//font...
const String selectedFont = 'ZenOldMincho';

//
const String kFindingString = "checking...";

//Rain Decision
enum RainDecision {
  notDetected,
  noRain,
  mayRain,
  mustRain,
}
