import '../models/weather_forecast.dart';
import '../services/connect_API_forecast_weather.dart';

class ForecastWeatherRepository {

  ConnectToAPIForecast connectToAPIForecast = ConnectToAPIForecast();

  Future<List<ForecastData>?> getForecastData(String city, int days) => connectToAPIForecast.getForecastWeather(city, days);

}