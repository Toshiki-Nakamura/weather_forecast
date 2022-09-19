import 'package:flutter/material.dart';
import 'package:weather_forecast/provider/address_data.dart';
import 'package:weather_forecast/provider/weather_data.dart';
import 'package:provider/provider.dart';

class CurrentColumn extends StatelessWidget {
  const CurrentColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherData weatherData = Provider.of<WeatherData>(context);
    return Column(
        children: [
          const SizedBox(height: 50),
          Text('${context.watch<AddressData>().address}', style: const TextStyle(fontSize: 25)),
          Text(weatherData.currentWeather.descripttion ?? 'No'),
          Text('${weatherData.currentWeather.temp ?? 0}°',style: const TextStyle(fontSize: 80)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('最高:${weatherData.currentWeather.tempMax}°'),
              const SizedBox(width: 6,),
              Text('最低:${weatherData.currentWeather.tempMin}°'),
            ],
          ),
          const SizedBox(height: 50),
        ],
    );
  }
}
