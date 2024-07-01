import 'package:dio/dio.dart';
import '../models/weather_data.dart';

class ConnectToAPI {

  final String apiKey = 'bb188deb61d54498980105501242806';

  Future<List<WeatherData>?> getWeather(String city, int days) async {
    List<WeatherData> parsedData = [];
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
          WeatherData data = WeatherData(
              name: response.data['location']['name'],
              country: response.data['location']['country'],
              last_updated: response.data['current']['last_updated'].toString(),
              temp_c: response.data['current']['temp_c'],
              text: response.data['current']['condition']['text']
          );
          parsedData.add(data);
          return parsedData;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }




}