import 'package:flutter/material.dart';
import 'package:weather_forecast/provider/address_data.dart';
import 'package:weather_forecast/provider/weather_data.dart';
import 'package:provider/provider.dart';

class CurrentColumn extends StatelessWidget {
  const CurrentColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: 50),
          Text('${context.watch<AddressData>().address}', style: const TextStyle(fontSize: 25)),
          Text(context.watch<WeatherData>().currentWeather.descripttion ?? 'No'),
          Text('${context.watch<WeatherData>().currentWeather.temp ?? 0}°',style: const TextStyle(fontSize: 80)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('最高:${context.watch<WeatherData>().currentWeather.tempMax}°'),
              const SizedBox(width: 6,),
              Text('最低:${context.watch<WeatherData>().currentWeather.tempMin}°'),
            ],
          ),
          const SizedBox(height: 50),
        ],
    );
  }
}
