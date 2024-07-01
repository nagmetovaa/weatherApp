import 'dart:ffi';

class WeatherData {
  String name;
  String country;
  String last_updated;
  double temp_c;
  String text;


  WeatherData({
    required this.name,
    required this.country,
    required this.last_updated,
    required this.temp_c,
    required this.text
  });



}