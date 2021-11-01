import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:umbrella/widget/pie_chart.dart';
import '../constant/constant.dart';

class ResultPieCard extends StatelessWidget {
  const ResultPieCard(
      {Key? key,
      required this.cardColor,
      required this.textColor,
      required this.willRain,
      required this.willNotRain})
      : super(key: key);

  final Color cardColor;
  final Color textColor;

  final int willRain;
  final int willNotRain;

  bool isValidRainData() {
    if (willRain == 0 && willNotRain == 0) {
      return false;
    }
    return true;
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
                          "Raining possibility",
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
                    child: PieChartCard(
                      willRain: willRain,
                      willNotRain: willNotRain,
                      isValidData: isValidRainData(),
                    ),
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
                          isValidRainData()
                              ? "$willRain% chance of raining and $willNotRain% chance of not raining."
                              : "What is the chance of raining and not raining?",
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
