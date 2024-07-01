abstract class WeatherState{}

class WeatherEmptyState extends WeatherState{}

class WeatherLoadState extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  List <dynamic>? loadedWeatherdata;
  WeatherLoadedState({required this.loadedWeatherdata}) : assert(loadedWeatherdata != null);
}
class WeatherErrorState extends WeatherState {
  print(e) {
    throw UnimplementedError();
  }
}