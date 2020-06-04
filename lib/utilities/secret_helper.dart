import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class SecretHelper {
  Future<String> loadApiKey() async {
    return await rootBundle
        .loadString('assets/secrets.json')
        .then((value) => jsonDecode(value)['OpenWeatherMapApiKey']);
  }
}
