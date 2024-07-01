import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/weather_forecast.dart';
import '../../repositories/forecast_data_repository.dart';
import 'forecast_event.dart';
import 'forecast_state.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {

  final ForecastWeatherRepository forecastWeatherRepository;

  ForecastBloc({required this.forecastWeatherRepository}) : super(ForecastLoadState()) {
    on<ForecastEvent>((event, emit) async {
      if (event is ForecastEvent) {
        await mapEventToState(event, emit);
      }
    });
  }

  Future<void> mapEventToState(ForecastEvent event, Emitter<ForecastState> emit) async {
    try {
      List loadedWeatherdata = await getWeatherForCities(event.cities, event.days);
      emit(ForecastLoadedState(loadedForecastdata: loadedWeatherdata));
    } catch (e) {
      emit(ForecastErrorState());
      print('Error: $e');
    }
  }
  Future<List> getWeatherForCities(List<String> cities, int days) async {
    List<Future<List<ForecastData>?>> futures = cities.map((city) => forecastWeatherRepository.getForecastData(city, days)).toList();
    List<List<ForecastData>?> results = await Future.wait(futures);
    List weatherData = results.expand((data) => data ?? []).toList();

    return weatherData;
  }

}