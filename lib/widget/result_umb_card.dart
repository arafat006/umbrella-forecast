import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant/constant.dart';

class ResultUmbrellaCard extends StatelessWidget {
  ResultUmbrellaCard({
    Key? key,
    required this.cardColor,
    required this.textColor,
    required this.rainDecision,
  }) : super(key: key) {
    imgPath = rainDecisionImgPath(rainDecision);
    decision = decisionMaker(rainDecision);
  }

  final Color cardColor;
  final Color textColor;

  final RainDecision rainDecision;
  late String imgPath;
  late String decision;

  String rainDecisionImgPath(RainDecision rDecision) {
    if (rDecision == RainDecision.noRain) {
      return "assets/image/noRain.png";
    } else if (rDecision == RainDecision.mayRain) {
      return "assets/image/mayRain.gif";
    } else if (rDecision == RainDecision.mustRain) {
      return "assets/image/yesRain.gif";
    } else {
      return "assets/image/default_umbrella.png";
    }
  }

  String decisionMaker(RainDecision rDecision) {
    if (rDecision == RainDecision.noRain) {
      return "Ohh chill!!! No need of umbrella.";
    } else if (rDecision == RainDecision.mayRain) {
      return "Not so serious!!! but should keep umbrella.";
    } else if (rDecision == RainDecision.mustRain) {
      return "Be serious!!! Must take umbrella.";
    } else {
      return "Should you take umbrella or not?";
    }
  }

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
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Center(
                  child: Container(
                    // color: Colors.greenAccent,
                    margin: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "Umbrella decision",
                          style: TextStyle(
                            fontSize: 22,
                            color: kActiveColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'PTSerif',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.width / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    // color: Colors.greenAccent,
                    margin: const EdgeInsets.only(right: 5.0),
                    child: Image.asset(imgPath),
                  ),
                ),
              ),
              Flexible(
                child: Center(
                  child: Container(
                    // color: Colors.greenAccent,
                    margin: const EdgeInsets.only(right: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          decision,
                          style: TextStyle(
                            fontSize: kCardTopTextFontSize,
                            color: textColor,
                            fontWeight: kCardTopTextFontWeight,
                            fontFamily: 'PTSerif',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
