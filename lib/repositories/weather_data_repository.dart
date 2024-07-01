
import '../models/weather_data.dart';
import '../services/connect_API_current_weather.dart';

class CurrentWeatherRepository {

  ConnectToAPI connectToAPI = ConnectToAPI();

  Future<List<WeatherData>?> getWeatherData(String city, int days) => connectToAPI.getWeather(city, days);

}