import 'package:nilskrannig/utilities/secret_helper.dart';

import 'networking.dart';
import 'location.dart';

const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  String _weatherApiKey;
  SecretHelper _secretHelper;

  WeatherModel() {
    _secretHelper = SecretHelper();
  }

  Future<dynamic> getCityWeather(String cityName) async {
    await _getWeatherApiKey();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?q=$cityName&appid=$_weatherApiKey&units=metric');

    return await networkHelper.getData();
  }

  Future<dynamic> getLocationWeather() async {
    await _getWeatherApiKey();

    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$_weatherApiKey&units=metric');

    return await networkHelper.getData();
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }

  Future _getWeatherApiKey() async {
    if (_weatherApiKey == null) {
      _weatherApiKey = await _secretHelper.loadApiKey();
    }
  }
}
