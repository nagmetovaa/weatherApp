import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/forecast_weather/forecast_event.dart';
import '../bloc/forecast_weather/forecast_bloc.dart';
import '../bloc/forecast_weather/forecast_state.dart';
import '../models/weather_forecast.dart';
import '../repositories/forecast_data_repository.dart';

class WeatherDetail extends StatelessWidget {

  final forecastWeatherRepository = ForecastWeatherRepository();
  final String cityName;

   WeatherDetail({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${cityName}'),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/background_1.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          BlocProvider(
            create: (context) => ForecastBloc(forecastWeatherRepository: forecastWeatherRepository),
            child: ForecastDetailedView(cityName: cityName,),
          ),
        ],
      ),
    );
  }
}



class ForecastDetailedView extends StatefulWidget {
  const ForecastDetailedView({super.key, required this.cityName});

  @override
  _ForecastDetailedViewState createState() => _ForecastDetailedViewState();

  final String cityName;

}

class _ForecastDetailedViewState extends State<ForecastDetailedView> {
  late ForecastBloc forecastBloc;

  @override
  void initState() {
    super.initState();
    forecastBloc = BlocProvider.of<ForecastBloc>(context);
    forecastBloc.add(ForecastEvent( ['Astana', 'Almaty', 'Yakutsk'],  3));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForecastBloc, ForecastState>(
      builder: (context, state) {
        if (state is ForecastLoadState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ForecastLoadedState) {
          List<ForecastData> filteredForecastData = [];
          // print(state.loadedForecastdata!.length);
          for (int i = 0; i < state.loadedForecastdata!.length; i++) {
            ForecastData forecast = state.loadedForecastdata![i];
            if (forecast.name == widget.cityName) {
              filteredForecastData.add(forecast);
            }
          }
          return ListView.builder(
            itemCount: filteredForecastData?.length,
            itemBuilder: (context, index) {
              ForecastData forecastWeatherData = filteredForecastData![index];
              String cityName = forecastWeatherData.name;
              String temperature = forecastWeatherData.avgtemp_c.toStringAsFixed(1);
              String date = forecastWeatherData.date;
              String text = forecastWeatherData.text;
              return Column(
                children: [
                  ListTile(
                    title: Row(
                  children: [
                    Text(date, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                    Spacer(),
                    Text('Temperature: $temperature °C', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
                    subtitle: Text(text, style: TextStyle(color: Colors.white, fontSize: 15),),
                  ),
                  Divider(
                    color: Colors.blue[800],
                    thickness: 1.0,
                  ),
                ],
              );
            },
          );
        } else if (state is ForecastErrorState) {
          return Center(child: Text('Error'));
        } else {
          return Center(child: Text('No data'));
        }
      },
    );
  }

  @override
  void dispose() {
    forecastBloc.close();
    super.dispose();
  }
}

