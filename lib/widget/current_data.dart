import 'package:flutter/material.dart';
import 'package:weather_forecast/provider/data.dart';
import 'package:provider/provider.dart';

class CurrentData extends StatelessWidget {
  const CurrentData({super.key});

  @override
  Widget build(BuildContext context) {
    final Data data = Provider.of<Data>(context);
    return Container(
      child: Column(
          children: [
            const SizedBox(height: 50),
            Text('${data.address}', style: const TextStyle(fontSize: 25)),
            Text(data.currentWeather.descripttion ?? 'No'),
            Text('${data.currentWeather.temp ?? 0}°',style: const TextStyle(fontSize: 80)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('最高:${data.currentWeather.tempMax}°'),
                const SizedBox(width: 6,),
                Text('最低:${data.currentWeather.tempMin}°'),
              ],
            ),
            const SizedBox(height: 50),
          ],
      ),
    );
  }
}
