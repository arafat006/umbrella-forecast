import 'dart:convert';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:umbrella/storage/date_time.dart';
import 'package:umbrella/storage/rain_data.dart';
import 'package:umbrella/storage/storage.dart';
import 'package:umbrella/widget/rect_card.dart';
import 'package:umbrella/widget/result_button.dart';
import 'package:umbrella/widget/result_pie_card.dart';
import 'package:umbrella/widget/result_umb_card.dart';
import 'package:umbrella/widget/watch_card.dart';
import 'constant/constant.dart';

int _hour = 0;
int _minute = 0;
String _dayDiv = "AM";
bool isForecastReady = false;

List<int> forecastHoursArray = List.filled(24, 0, growable: false);
const String apiKey = ''; //use your own api
var rainData = RainData();

void watchTime() {
  print("Hour : $_hour Minute : $_minute");
}

void main() {
  runApp(const Umbrella());
}

class Umbrella extends StatelessWidget {
  const Umbrella({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff065596),
        ),
        scaffoldBackgroundColor: kScaffoldBackColor,
      ),
      home: MainApp(
        storage: CounterStorage(),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  void enterFullScreen(FullScreenMode fullScreenMode) async {
    await FullScreen.enterFullScreen(fullScreenMode);
  }

  // double posLat = rainData.posLat;
  // double posLon = rainData.posLon;

  Color validityColor = Colors.red;
  String validity = kFindingString;
  String apiDate = kFindingString;
  String location = kFindingString;

  int willRain = 0;
  int willNotRain = 0;

  RainDecision rainDecision = RainDecision.notDetected;

  //start preparation...
  void getPreparationForStart() {}

  //location related...
  bool isCoordinateAvailable() {
    if (rainData.posLat == 1000000.0 && rainData.posLon == 1000000.0) {
      return false;
    }
    return true;
  }

  void permissionMustForFirstTime() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Location error',
      desc: 'Give permission to access location',
      btnOkText: 'Got it!',
      // btnCancelOnPress: () {},
      dismissOnTouchOutside: false,
      btnOkOnPress: () {
        getCoordinates();
      },
    ).show();
  }

  void internetConnectionErrorShow() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Connection Error!',
      desc: 'Check your internet connection and try again',
      btnOkText: 'Got it!',
      dismissOnTouchOutside: false,
      // btnCancelOnPress: () {},
      btnOkOnPress: () {
        getCoordinates();
      },
    ).show();
  }

  bool isLocalLocationAvailable() {
    if (rainData.getLocationData() != "none") {
      return true;
    }
    return false;
  }

  //refresh related...
  void refreshCoordinates() async {
    // print('refreshing coordinates');
    // Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Permission not given. Now asking permission...');

      LocationPermission asked = await Geolocator.requestPermission();
      if (asked == LocationPermission.always ||
          asked == LocationPermission.whileInUse) {
        //
        try {
          Position currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          print("latitude " + currentPosition.latitude.toString());
          print("longitude " + currentPosition.longitude.toString());

          // getWeatherData();

          rainData.posLat = currentPosition.latitude;
          rainData.posLon = currentPosition.longitude;

          refreshWeatherDataSaveLocal();
        } catch (e) {
          print(e);
          permissionMustForFirstTime();
          return;
        }
      } //
      else {
        //if permission is not granted
        permissionMustForFirstTime();
        return;
      }
    } //
    else {
      //
      // print('refresh coordinates in else...');
      try {
        Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        print("latitude " + currentPosition.latitude.toString());
        print("longitude " + currentPosition.longitude.toString());

        rainData.posLat = currentPosition.latitude;
        rainData.posLon = currentPosition.longitude;

        refreshWeatherDataSaveLocal();
      } catch (e) {
        print(e);
        permissionMustForFirstTime();
        return;
      }
    }
  }

  void refreshWeatherDataSaveLocal() async {
    //
    try {
      var urlForecast = Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=' +
              rainData.posLat.toString() +
              ',' +
              rainData.posLon.toString());

      // print(urlForecast.toString());
      print("Lat:${rainData.posLat} Lon:${rainData.posLon}");

      Response response = await get(urlForecast);
      print((response.statusCode).runtimeType);
      //print(response.body);
      if (response.statusCode == 200) {
        //
        String data = response.body;
        String bindWeatherData = "";
        //Get date, sun rise, sun set...
        var onlyDate = jsonDecode(data)['forecast']['forecastday'][0]['date'];
        var location = jsonDecode(data)['location']['name'];
        var sunRise =
            jsonDecode(data)['forecast']['forecastday'][0]['astro']['sunrise'];
        var sunSet =
            jsonDecode(data)['forecast']['forecastday'][0]['astro']['sunset'];

        //Data binding...
        bindWeatherData = onlyDate +
            "+" +
            location +
            "+" +
            sunRise +
            "+" +
            sunSet +
            "+" +
            rainData.posLat.toString() +
            "+" +
            rainData.posLon.toString();

        print(bindWeatherData);

        for (int i = 0; i < 24; i++) {
          var rain = jsonDecode(data)['forecast']['forecastday'][0]['hour'][i]
              ['will_it_rain'];
          // print(rain);
          var chance = jsonDecode(data)['forecast']['forecastday'][0]['hour'][i]
              ['chance_of_rain'];
          // print(chance);

          bindWeatherData =
              bindWeatherData + "+" + rain.toString() + "+" + chance.toString();
        }

        // print("API Date = " + onlyDate);
        // print("Current Date = " + DateTimeKeeper().getCurrentDate());

        var file = await widget.storage.writeCounter(bindWeatherData);
        // print(file.path);

        //
        if (onlyDate != DateTimeKeeper().getCurrentDate()) {
          dateUpdateProblem();
          return;
        }

        if (!["", null, false, 0].contains(file)) {
          //getLocalWeatherData();
          getDataFromLocal();
        }

        //
      } else if (response.statusCode == 401) {
        print('invalid api key');

        invalidApiDialogueShow();
      } else {
        print('no response');

        networkProblemDialogueShow();
      }
    } catch (e) {
      print("Custom Exception: " + e.toString());
      networkProblemDialogueShow();
    }
  }

  //get ready local storage...
  void getDataFromLocal() async {
    widget.storage.readCounter().then((var value) {
      //
      try {
        setState(() {
          List<String> extInfo = value.toString().split('+');
          rainData.setDayInfo(
              date: extInfo[0],
              location: extInfo[1],
              sunRise: extInfo[2],
              sunSet: extInfo[3]);

          rainData.posLat = double.parse(extInfo[4]);
          rainData.posLon = double.parse(extInfo[5]);

          //date, location, sunRise, sunSet, lat, lon, hourData[24]

          // print("Length : " + extInfo.length.toString());
          for (int i = 6; i < extInfo.length; i += 2) {
            rainData.setHourData(
                int.parse(extInfo[i]), int.parse(extInfo[i + 1]));

            // print(i);
            // print("rain : " + extInfo[i] + "  " + "percent : " + extInfo[i + 1]);
          }
          //

          location = rainData.getLocationData();

          apiDate = rainData.getDate();
          if (rainData.getDate() == DateTimeKeeper().getCurrentDate()) {
            validity = "Updated";
          } else {
            validity = "Outdated";
          }
          //
        });

        //
      } catch (e) {
        setState(() {
          apiDate = "none";
          validity = "Outdated";
          location = "Not found";
        });
        //
        print("Exeption Error: " + e.toString());
      }

      //check Location...
      print("Checking Data...");
      if (location == "Not found" || location == kFindingString) {
        //if no location...
        getCoordinates();
      } //
      else {
        // if location found...
        if (apiDate == DateTimeKeeper().getCurrentDate()) {
          //if Date updated
          isForecastReady = true;
          print('success retrive all data...');
        } //
        else {
          //if Date not updated
          getWeatherDataSaveLocal();
        }
      }
      //
    });
  }

  void getCoordinates() async {
    // Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Permission not given. Now asking permission...');

      LocationPermission asked = await Geolocator.requestPermission();
      if (asked == LocationPermission.always ||
          asked == LocationPermission.whileInUse) {
        //
        try {
          Position currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          print("latitude " + currentPosition.latitude.toString());
          print("longitude " + currentPosition.longitude.toString());

          // getWeatherData();

          rainData.posLat = currentPosition.latitude;
          rainData.posLon = currentPosition.longitude;

          // Dummy Test...
          // rainData.posLat = 59.710486;
          // rainData.posLon = -151.482048;

          getWeatherDataSaveLocal();
          // if (rainData.posLat == currentPosition.latitude) {}
        } catch (e) {
          print(e);
          permissionMustForFirstTime();
          return;
        }
      } //
      else {
        //if permission is not granted
        permissionMustForFirstTime();
        return;
      }
    } //
    else {
      //
      try {
        Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        print("latitude " + currentPosition.latitude.toString());
        print("longitude " + currentPosition.longitude.toString());

        rainData.posLat = currentPosition.latitude;
        rainData.posLon = currentPosition.longitude;

        // Dummy Test...
        // rainData.posLat = 59.710486;
        // rainData.posLon = -151.482048;

        getWeatherDataSaveLocal();
        // if (isLocalLocationAvailable()) {
        //   getLocalWeatherData();
        // }

      } catch (e) {
        print(e);
        permissionMustForFirstTime();
        return;
      }
    }
  }

  void getWeatherDataSaveLocal() async {
    //
    try {
      if (!isCoordinateAvailable()) {
        getCoordinates();
        return;
      }

      var urlForecast = Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=' +
              rainData.posLat.toString() +
              ',' +
              rainData.posLon.toString());

      // print(urlForecast.toString());
      print("Lat:${rainData.posLat} Lon:${rainData.posLon}");

      Response response = await get(urlForecast);
      print((response.statusCode).runtimeType);
      //print(response.body);
      if (response.statusCode == 200) {
        //
        String data = response.body;
        String bindWeatherData = "";
        //Get date, sun rise, sun set...
        var onlyDate = jsonDecode(data)['forecast']['forecastday'][0]['date'];
        var location = jsonDecode(data)['location']['name'];
        var sunRise =
            jsonDecode(data)['forecast']['forecastday'][0]['astro']['sunrise'];
        var sunSet =
            jsonDecode(data)['forecast']['forecastday'][0]['astro']['sunset'];

        //Data binding...
        bindWeatherData = onlyDate +
            "+" +
            location +
            "+" +
            sunRise +
            "+" +
            sunSet +
            "+" +
            rainData.posLat.toString() +
            "+" +
            rainData.posLon.toString();

        print(bindWeatherData);

        for (int i = 0; i < 24; i++) {
          var rain = jsonDecode(data)['forecast']['forecastday'][0]['hour'][i]
              ['will_it_rain'];
          // print(rain);
          var chance = jsonDecode(data)['forecast']['forecastday'][0]['hour'][i]
              ['chance_of_rain'];
          // print(chance);

          bindWeatherData =
              bindWeatherData + "+" + rain.toString() + "+" + chance.toString();
        }

        // print("API Date = " + onlyDate);
        // print("Current Date = " + DateTimeKeeper().getCurrentDate());

        var file = await widget.storage.writeCounter(bindWeatherData);
        // print(file.path);

        //
        if (onlyDate != DateTimeKeeper().getCurrentDate()) {
          validity = "Outdated";
          dateUpdateProblem();
          return;
        }

        if (!["", null, false, 0].contains(file)) {
          //getLocalWeatherData();
          getDataFromLocal();
        }

        //
      } else if (response.statusCode == 401) {
        print('invalid api key');

        invalidApiDialogueShow();
      } else {
        print('no response');

        networkProblemDialogueShow();
      }
    } catch (e) {
      print("Custom Exception: " + e.toString());
      networkProblemDialogueShow();
    }
  }

  void dateUpdateProblem() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Date Outdated!',
      desc: 'Please try after some moment',
      btnOkText: 'Got it!',
      dismissOnTouchOutside: false,
      btnOkOnPress: () {
        getWeatherDataSaveLocal();
      },
    ).show();
  }

  void networkProblemDialogueShow() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'No connection!',
      desc: 'Please check your internet connection and try again',
      btnOkText: 'Got it!',
      dismissOnTouchOutside: false,
      btnOkOnPress: () {
        getWeatherDataSaveLocal();
      },
    ).show();
  }

  void invalidApiDialogueShow() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Invalid API',
      desc: 'Please renew your API key',
      btnOkText: 'Got it!',
      dismissOnTouchOutside: false,
      btnOkOnPress: () {
        getWeatherDataSaveLocal();
      },
    ).show();
  }

  //Watch related...
  void hourIncrease() {
    setState(() {
      if (_hour == 12) {
        _hour = 1;
      } else {
        _hour++;
      }
    });
    watchTime();
  }

  void hourDecrease() {
    setState(() {
      if (_hour == 1) {
        _hour = 12;
      } else {
        _hour--;
      }
    });
    watchTime();
  }

  void minuteIncrease() {
    setState(() {
      if (_minute == 59) {
        _minute = 0;
      } else {
        _minute++;
      }
    });
    watchTime();
  }

  void minuteDecrease() {
    setState(() {
      if (_minute == 0) {
        _minute = 59;
      } else {
        _minute--;
      }
    });
    watchTime();
  }

  void alternateDayDiv() {
    setState(() {
      if (_dayDiv == "AM") {
        _dayDiv = "PM";
      } else {
        _dayDiv = "AM";
      }
    });
  }

  int getDayDivPriorityIndex(String dDiv) {
    if (dDiv == "AM") {
      return 0;
    } else {
      return 1;
    }
  }

  void setWatchCurrentTime(int hour, int minute, String dDiv) {
    setState(() {
      _hour = hour;
      _minute = minute;
      _dayDiv = dDiv;
    });
  }

  bool checkWatchAndCurrentTimeValidity() {
    //

    if (DateTimeKeeper().convert12To24HourFormat(_hour, _dayDiv) >
        DateTimeKeeper().getCurrentHour24HF()) {
      //
      return true;
    } else if (DateTimeKeeper().convert12To24HourFormat(_hour, _dayDiv) ==
        DateTimeKeeper().getCurrentHour24HF()) {
      if (_minute > DateTimeKeeper().getCurrentMinute()) {
        return true;
      }
    }

    return false;
  }

  //Hour Index related...
  void resetHourIndexArray() {
    forecastHoursArray = List.filled(24, 0);
  }

  List<int> calculateForecastHoursArray() {
    int startIndex = DateTimeKeeper().getCurrentHour24HF();
    int endIndex = DateTimeKeeper().convert12To24HourFormat(_hour, _dayDiv);

    resetHourIndexArray();
    for (; startIndex <= endIndex; startIndex++) {
      forecastHoursArray[startIndex] = 1;
    }

    print(forecastHoursArray);
    return forecastHoursArray;
  }

  RainDecision rainDecisionGenerator(int decValue) {
    if (decValue == 0) {
      return RainDecision.noRain;
    } else if (1 <= decValue && decValue < 50) {
      return RainDecision.mayRain;
    } else {
      return RainDecision.mustRain;
    }
  }

  void generateForecastResult() {
    //
    List<int> hourArray_ = calculateForecastHoursArray();
    List<int> percentageArray_ = List.filled(24, 0);

    for (int i = 0; i < hourArray_.length; i++) {
      if (hourArray_[i] == 1) {
        percentageArray_[i] = rainData.getRainPercentage(i);
      }
    }
    print(percentageArray_);

    int maxPercentage_ = percentageArray_.reduce(max);
    print(maxPercentage_);

    setState(() {
      willRain = maxPercentage_;
      willNotRain = 100 - maxPercentage_;
      rainDecision = rainDecisionGenerator(willRain);
    });
  }

  //umbrella button...
  void umbrellaButtonOnPress() {
    print("Lat:" + rainData.posLat.toString());
    print("Lon:" + rainData.posLon.toString());

    if (checkWatchAndCurrentTimeValidity()) {
      //
      // validWatchTimeForForecast();
      if (apiDate == DateTimeKeeper().getCurrentDate()) {
        if (isForecastReady) {
          generateForecastResult();
        } //
        else {
          getWeatherDataSaveLocal();
        }
      } //
      else {
        isForecastReady = false;
        getWeatherDataSaveLocal();
      }

      // calculateForecastHoursArray();
      // getWeatherData();
      //
    } else {
      //
      invalidWatchTimeForForecast();
    }
  }

  //Dialogue box related...
  void invalidWatchTimeForForecast() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Error Forecast Time',
      desc: 'Set watch time to future',
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
  }

  void validWatchTimeForForecast() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Success',
      desc: 'Success forecast value.',
      btnOkOnPress: () {},
    ).show();
  }

  // String currentDate = DateTimeKeeper().getDateFromKeeper();

  @override
  void initState() {
    super.initState();
    enterFullScreen(FullScreenMode.EMERSIVE_STICKY);

    _hour = DateTimeKeeper().getCurrentHour12HF();
    _minute = DateTimeKeeper().getCurrentMinute();
    _dayDiv = DateTimeKeeper().getCurrentDayDiv();

    // if (!isCoordinateAvailable()) {
    //   getCoordinates();
    // }
    getDataFromLocal();
    // getLocalWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            children: const [
              // Image.asset(
              //   'assets/image/yesRain.gif',
              //   height: 40.0,
              //   width: 40.0,
              // ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                'Umbrella (Forecast)',
                style: TextStyle(
                  fontFamily: 'PTSerif',
                  fontSize: 21.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: 70.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CardRect(
                cardColor: kCardBackColor,
                topText: apiDate,
                bottomText: validity,
                topTextColor: Colors.white,
                bottomTextColor:
                    validity == "Outdated" || validity == kFindingString
                        ? kInActiveColor
                        : kActiveColor,
                buttonIcon: Icons.refresh,
                onPress: () {
                  refreshWeatherDataSaveLocal();
                },
              ),
              CardRect(
                cardColor: kCardBackColor,
                topText: location,
                bottomText: "Location",
                topTextColor: Colors.white,
                bottomTextColor:
                    location == "Not found" || location == kFindingString
                        ? kInActiveColor
                        : kActiveColor,
                buttonIcon: Icons.refresh,
                onPress: () {
                  refreshCoordinates();
                },
              ),
              WatchCard(
                hourIncrease: () {
                  hourIncrease();
                },
                hourDecrease: () {
                  hourDecrease();
                },
                minuteIncrease: () {
                  minuteIncrease();
                },
                minuteDecrease: () {
                  minuteDecrease();
                },
                alternateDayDiv: () {
                  alternateDayDiv();
                },
                minute: _minute,
                hour: _hour,
                dayDiv: _dayDiv,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: ResultButton(onPress: () {
                  umbrellaButtonOnPress();
                }),
              ),
              ResultPieCard(
                cardColor: kCardBackColor,
                textColor: Colors.white,
                willRain: willRain,
                willNotRain: willNotRain,
              ),
              ResultUmbrellaCard(
                cardColor: kCardBackColor,
                textColor: Colors.white,
                rainDecision: rainDecision,
              ),
              const SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
