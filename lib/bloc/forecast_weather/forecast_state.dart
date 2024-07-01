abstract class ForecastState{}

class ForecastLoadState extends ForecastState {}

class ForecastLoadedState extends ForecastState {
  List <dynamic>? loadedForecastdata;
  ForecastLoadedState({required this.loadedForecastdata}) : assert(loadedForecastdata != null);
}
class ForecastErrorState extends ForecastState {
  print(e) {
    throw UnimplementedError();
  }
}