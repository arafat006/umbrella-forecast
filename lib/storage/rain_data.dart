// import 'dart:math';
import 'package:umbrella/storage/per_hour.dart';

class RainData {
  String _date = "none";
  String _location = "none";
  String _sunRise = "none";
  String _sunSet = "none";

  double posLat = 1000000.0;
  double posLon = 1000000.0;

  List<HourData> _hourData = [];

  void setLocationData(String location) {
    _location = location;
  }

  String getLocationData() {
    return _location;
  }

  void setHourData(int rain, int chance) {
    _hourData.add(HourData(rain: rain, chance: chance));
  }

  int getRainPercentage(int index) {
    return _hourData[index].rain * _hourData[index].chance;
    // return (Random().nextInt(100) + 1);
  }

  void setDayInfo(
      {required String date,
      required String location,
      required String sunRise,
      required String sunSet}) {
    _date = date;
    _location = location;
    _sunRise = sunRise;
    _sunSet = sunSet;
  }

  String getDate() {
    return _date;
  }

  String getSunRise() {
    return _sunRise;
  }

  String getSunSet() {
    return _sunSet;
  }

  bool availableRainData() {
    if (_date == "none") {
      return false;
    } else {
      return false;
    }
  }
}
