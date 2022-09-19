import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/provider/weather_data.dart';
import 'package:provider/provider.dart';

class HourlyView extends StatelessWidget {
  const HourlyView({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherData data = Provider.of<WeatherData>(context);
    return Column(
      children: [
        const Divider(height: 0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: data.perHourWeather.map((weather) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Column(
                  children: [
                    Text('${DateFormat('H').format(weather.time!)}時'),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('${weather.rainyPercent}%', style: const TextStyle(color: Colors.blue),),
                    ),
                    Image.network('https://openweathermap.org/img/wn/${weather.icon}.png', width: 30,),
                    Padding(padding: const EdgeInsets.only(top: 8), child: Text('${weather.temp}'),),
                  ]
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }
}
