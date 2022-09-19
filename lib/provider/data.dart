import 'package:flutter/material.dart';
import 'package:weather_forecast/repository/weather.dart';
import 'package:provider/provider.dart'; 

class Data extends ChangeNotifier {
  Weather currentWeather = Weather(temp: 18, descripttion: '晴れ', tempMax: 22, tempMin: 14);

  List<Weather> perHourWeather = List.generate(15, (i) => 
    Weather(temp: 15+i,descripttion: '晴れ',tempMax: 22,tempMin: 14,time: DateTime(2022,9,16,8+(i*2)),rainyPercent: 0)
  );

  List<Weather> dailyWeather = List.generate(7, (i) => 
    Weather(temp: 20, descripttion: '晴れ',tempMax: 22-i, tempMin: 14, time: DateTime(2022, 9, 16 + i), rainyPercent: 0)
  );

  void setNotify(Weather current, List<Weather> perHour, List<Weather> daily) {
    currentWeather = current;
    perHourWeather = perHour;
    dailyWeather = daily;
    notifyListeners();
  }
}
