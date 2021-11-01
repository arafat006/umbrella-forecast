import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'card_button.dart';
import '../constant/constant.dart';

class CardRect extends StatelessWidget {
  const CardRect(
      {Key? key,
      required this.cardColor,
      required this.topText,
      required this.bottomText,
      required this.topTextColor,
      required this.bottomTextColor,
      required this.buttonIcon,
      required this.onPress})
      : super(key: key);

  final Color cardColor;

  final String topText;
  final String bottomText;

  final Color topTextColor;
  final Color bottomTextColor;
  final IconData buttonIcon;
  final Function onPress;

  // String getTopString(String TS) {
  //   if (TS == "not found") {
  //     return TS;
  //   } else if (TS == "none") {
  //     return TS;
  //   } else {
  //     return TS;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: kCardBorderColor.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Center(
              child: Container(
                // color: Colors.greenAccent,
                margin: const EdgeInsets.only(right: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      topText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: kCardTopTextFontSize,
                        color: topTextColor,
                        fontWeight: kCardTopTextFontWeight,
                        fontFamily: selectedFont,
                      ),
                    ),
                    Text(
                      bottomText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: bottomTextColor,
                        fontSize: kCardBottomTextFontSize,
                        fontWeight: kCardBottomTextFontWeight,
                        fontFamily: selectedFont,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          RoundIconButton(
            icon: buttonIcon,
            onPress: () {
              onPress();
            },
          ),
        ],
      ),
    );
  }
}
