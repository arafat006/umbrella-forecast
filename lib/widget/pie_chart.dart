import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:umbrella/constant/constant.dart';

class PieChartCard extends StatelessWidget {
  const PieChartCard(
      {Key? key,
      required this.willRain,
      required this.willNotRain,
      required this.isValidData})
      : super(key: key);

  final int willRain;
  final int willNotRain;
  final bool isValidData;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: {
        "Yes": willRain.toDouble(),
        "No": willNotRain.toDouble(),
      },
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3,
      colorList: const [
        kInActiveColor,
        kActiveColor,
      ],
      initialAngleInDegree: 0,
      emptyColor: kEmptyColor,
      chartType: ChartType.disc,
      ringStrokeWidth: 50,
      centerText: !isValidData ? "Rain \npercentage?" : "",
      centerTextStyle: const TextStyle(
        color: Colors.white,
      ),
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: false,
        legendTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        chartValueStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        showChartValueBackground: false,
        chartValueBackgroundColor: Colors.white,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
    );
  }
}
