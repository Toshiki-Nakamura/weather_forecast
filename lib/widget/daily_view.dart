import 'package:flutter/material.dart';
import 'package:weather_forecast/provider/data.dart';
import 'package:provider/provider.dart';

class DailyView extends StatelessWidget {
  DailyView({super.key});

  final List<String> weekDay = ['月','火', '水', '木', '金', '土', '日'];

  @override
  Widget build(BuildContext context) {
    final Data data = Provider.of<Data>(context);
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: data.dailyWeather.map((weather) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Colors.white, width: 50,
                    child: Text('${weekDay[(weather.time?.weekday ?? 1) - 1]}曜日'),
                  ),
                  Row(
                    children: [
                      Image.network('https://openweathermap.org/img/wn/${weather.icon}.png', width: 30,),
                      Text('${weather.rainyPercent}%', style: const TextStyle(color: Colors.blue),),
                    ],
                  ),
                  Container(
                    color: Colors.white, width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${weather.tempMax}', style: const TextStyle(fontSize: 14),),
                        Text('${weather.tempMin}', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
