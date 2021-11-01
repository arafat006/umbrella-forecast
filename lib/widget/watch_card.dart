import 'package:flutter/material.dart';
import 'package:umbrella/constant/constant.dart';
import 'package:umbrella/widget/watch_button.dart';

class WatchCard extends StatelessWidget {
  const WatchCard({
    Key? key,
    required this.hourIncrease,
    required this.hourDecrease,
    required this.minuteIncrease,
    required this.minuteDecrease,
    required this.alternateDayDiv,
    required this.hour,
    required this.minute,
    required this.dayDiv,
  }) : super(key: key);

  final int hour;
  final int minute;
  final String dayDiv;

  final Function hourIncrease;
  final Function hourDecrease;
  final Function minuteIncrease;
  final Function minuteDecrease;
  final Function alternateDayDiv;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        // color: kCardBackColor,
        color: Colors.black54,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: kCardBorderColor.withOpacity(0.5),
            // color: kScaffoldBackColor.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 0),
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
                    margin: const EdgeInsets.only(
                        top: 0.0, left: 10.0, right: 10.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "Forecast Watch",
                          style: TextStyle(
                            fontSize: 26,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                color: kButtonBackColor,
                height: kWatchButtonHeight,
                width: kWatchButtonWidth,
                margin: const EdgeInsets.only(right: 5.0),
                child: WatchButton(
                  icon: Icons.add,
                  onPress: () {
                    hourIncrease();
                  },
                ),
              ),
              Container(
                color: kButtonBackColor,
                height: kWatchButtonHeight,
                width: kWatchButtonWidth,
                margin: const EdgeInsets.only(right: 5.0),
                child: WatchButton(
                  icon: Icons.add,
                  onPress: () {
                    minuteIncrease();
                  },
                ),
              ),
              Container(
                color: kButtonBackColor,
                height: kWatchButtonHeight,
                width: kWatchButtonWidth,
                margin: const EdgeInsets.only(right: 5.0),
                child: WatchButton(
                  icon: Icons.arrow_drop_up_outlined,
                  onPress: () {
                    alternateDayDiv();
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  width: 90.0,
                  padding: const EdgeInsets.all(10.0),
                  color: kDialBackColor,
                  margin: const EdgeInsets.only(right: 5.0),
                  child: Column(
                    children: [
                      Text(
                        hour < 10 ? "0" + hour.toString() : hour.toString(),
                        style: const TextStyle(
                          fontSize: kWatchFontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PTSerif',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  width: 90.0,
                  padding: const EdgeInsets.all(10.0),
                  color: kDialBackColor,
                  margin: const EdgeInsets.only(right: 5.0),
                  child: Column(
                    children: [
                      Text(
                        minute < 10
                            ? "0" + minute.toString()
                            : minute.toString(),
                        style: const TextStyle(
                          fontSize: kWatchFontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PTSerif',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 90.0,
                  color: kDialBackColor,
                  margin: const EdgeInsets.only(right: 5.0),
                  child: Column(
                    children: [
                      Text(
                        dayDiv,
                        style: const TextStyle(
                          fontSize: kWatchFontSize,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PTSerif',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                color: kButtonBackColor,
                height: kWatchButtonHeight,
                width: kWatchButtonWidth,
                margin: const EdgeInsets.only(right: 5.0),
                child: WatchButton(
                  icon: Icons.remove,
                  onPress: () {
                    hourDecrease();
                  },
                ),
              ),
              Container(
                color: kButtonBackColor,
                height: kWatchButtonHeight,
                width: kWatchButtonWidth,
                margin: const EdgeInsets.only(right: 5.0),
                child: WatchButton(
                  icon: Icons.remove,
                  onPress: () {
                    minuteDecrease();
                  },
                ),
              ),
              Container(
                color: kButtonBackColor,
                height: kWatchButtonHeight,
                width: kWatchButtonWidth,
                margin: const EdgeInsets.only(right: 5.0),
                child: WatchButton(
                  icon: Icons.arrow_drop_down_outlined,
                  onPress: () {
                    alternateDayDiv();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
