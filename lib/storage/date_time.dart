import 'package:intl/intl.dart';

class DateTimeKeeper {
  String getDateFromKeeper() {
    var currentDate = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(currentDate);
    return formattedDate;
    //print(formattedDate); // 2016-01-25
  }

  int getCurrentHour24HF() {
    var currentTime = DateTime.now();
    var formatter = DateFormat('HH');
    return int.parse(formatter.format(currentTime));
  }

  int getCurrentHour12HF() {
    var currentTime = DateTime.now();
    var formatter = DateFormat('hh');
    return int.parse(formatter.format(currentTime));
  }

  int getCurrentMinute() {
    var currentTime = DateTime.now();
    var formatter = DateFormat('mm');
    return int.parse(formatter.format(currentTime));
  }

  String getCurrentDayDiv() {
    var currentTime = DateTime.now();
    var formatter = DateFormat('a');
    return formatter.format(currentTime).toString();
  }

  int getCurrentDayDivPriorityIndex() {
    // var currentTime = DateTime.now();
    var formatter = DateFormat('a');

    if (formatter.toString() == "AM") {
      return 0;
    } else {
      return 1;
    }
  }

  int convert12To24HourFormat(int hour, String dDiv) {
    if (dDiv == "AM") {
      if (hour == 12) {
        return 0;
      }
      return hour;
    } else {
      if (hour == 12) {
        return 12;
      }
      return (hour + 12);
    }
  }

  String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  // int getCurrentTime24HourFormat() {
  //   String currentTime = getCurrentTimeFromKeeper();
  //   int currentTime24Hour;
  //   try {
  //     currentTime24Hour = int.parse(currentTime.split('-')[0]);
  //   } catch (e) {
  //     currentTime24Hour = 0;
  //     print(e);
  //   }
  //   return currentTime24Hour;
  // }
}
