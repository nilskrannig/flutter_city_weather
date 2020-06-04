import 'package:flutter/material.dart';
import 'package:nilskrannig/screens/city.dart';
import 'package:nilskrannig/utilities/constants.dart';
import 'package:nilskrannig/services/weather.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;

  LocationScreen({this.locationWeather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  int temperature;
  String weatherConditionMessage;
  String weatherIcon;
  String cityName;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _getLocationScreenBackgroundImage(),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weather = await weatherModel.getLocationWeather();
                      updateUI(weather);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: kLocationScreenIconSize,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedCityName = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return CityScreen();
                        }),
                      );

                      if (typedCityName != null) {
                        await weatherModel
                            .getCityWeather(typedCityName)
                            .then((value) => updateUI(value));
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: kLocationScreenIconSize,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherConditionMessage in $cityName!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        cityName = '';
        temperature = 0;
        weatherConditionMessage = 'Unable to get weather data.';
        weatherIcon = 'oops';
        return;
      }
      cityName = weatherData['name'];

      int weatherConditionId = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(weatherConditionId);

      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      weatherConditionMessage = weatherModel.getMessage(temperature);
    });
  }

  ImageProvider _getLocationScreenBackgroundImage() {
    return AssetImage('assets/images/location_background.jpg');
//    return NetworkImage();
  }
}
