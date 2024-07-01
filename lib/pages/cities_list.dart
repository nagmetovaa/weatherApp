import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/current_weather/weather_bloc.dart';
import 'package:weather_app/bloc/current_weather/weather_event.dart';
import 'package:weather_app/bloc/current_weather/weather_state.dart';
import 'package:weather_app/repositories/weather_data_repository.dart';
import '../models/weather_data.dart';
import 'detailed_view.dart';

class CitiesWeather extends StatelessWidget {

  final currentWeatherRepository = CurrentWeatherRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My cities list'),
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
        create: (context) => WeatherBloc(currentWeatherRepository: currentWeatherRepository),
        child: WeatherListView(),
      ),
      ],
      ),
    );
  }
}



class WeatherListView extends StatefulWidget {
  @override
  _WeatherListViewState createState() => _WeatherListViewState();
}

class _WeatherListViewState extends State<WeatherListView> {
  late WeatherBloc weatherBloc;

  @override
  void initState() {
    super.initState();
    weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(WeatherEvent( ['Astana', 'Almaty', 'Yakutsk'],  3));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoadState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoadedState) {
          return ListView.builder(
            itemCount: state.loadedWeatherdata?.length,
            itemBuilder: (context, index) {
              WeatherData currentWeatherData = state.loadedWeatherdata![index];
              String cityName = currentWeatherData.name;
              String temperature = currentWeatherData.temp_c.toStringAsFixed(1);
              return Column(
                children: [
                  ListTile(
                    title: Text(cityName, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                    subtitle: Text('Temperature: $temperature °C', style: TextStyle(color: Colors.white, fontSize: 15),),
                    trailing: CupertinoButton(
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherDetail(cityName: cityName,)
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(
                    color: Colors.blue[800],
                    thickness: 1.0,
                  ),
                ],
              );
            },
          );
        } else if (state is WeatherErrorState) {
          return Center(child: Text('Error'));
        } else {
          return Center(child: Text('No data'));
        }
      },
    );
  }

  @override
  void dispose() {
    weatherBloc.close();
    super.dispose();
  }
}