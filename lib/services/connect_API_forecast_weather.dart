import 'package:dio/dio.dart';
import '../models/weather_forecast.dart';

class ConnectToAPIForecast {

  final String apiKey = 'bb188deb61d54498980105501242806';

  Future<List<ForecastData>?> getForecastWeather(String city, int days) async {
    List<ForecastData> parsedData = [];
    try {
      Dio dio = Dio();

      Map<String, dynamic> queryParameters = {
        'key': apiKey,
        'q': city,
        'days': days.toString(),
        'aqi': 'no',
        'alerts': 'no',
      };
      Response response = await dio.get(
        'http://api.weatherapi.com/v1/forecast.json',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          List<ForecastData> forecastDataList = [];
          List<dynamic> forecastdayList = response.data['forecast']['forecastday'];
          for (var day in forecastdayList) {
            ForecastData forecastData = ForecastData(
              name: response.data['location']['name'],
              country: response.data['location']['country'],
              date: day['date'],
              avgtemp_c: day['day']['avgtemp_c'],
              text: day['day']['condition']['text'],
            );
            forecastDataList.add(forecastData);
          }
          return forecastDataList;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }




}