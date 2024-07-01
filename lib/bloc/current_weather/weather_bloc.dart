import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/current_weather/weather_event.dart';
import 'package:weather_app/bloc/current_weather/weather_state.dart';

import '../../models/weather_data.dart';
import '../../repositories/weather_data_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {

  final CurrentWeatherRepository currentWeatherRepository;

  WeatherBloc({required this.currentWeatherRepository}) : super(WeatherEmptyState()) {
    on<WeatherEvent>((event, emit) async {
      if (event is WeatherEvent) {
       await mapEventToState(event, emit);
      }
    });
  }

  Future<void> mapEventToState(WeatherEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoadState());
    try {
      List loadedWeatherdata = await getWeatherForCities(event.cities, event.days);
      emit(WeatherLoadedState(loadedWeatherdata: loadedWeatherdata));
    } catch (e) {
      emit(WeatherErrorState());
      print('Error: $e');
    }
  }
  Future<List> getWeatherForCities(List<String> cities, int days) async {
    List<Future<List<WeatherData>?>> futures = cities.map((city) => currentWeatherRepository.getWeatherData(city, days)).toList();
    List<List<WeatherData>?> results = await Future.wait(futures);
    List weatherData = results.expand((data) => data ?? []).toList();

    return weatherData;
  }

}