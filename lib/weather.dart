import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Weather {
  int? temp = 0; //気温
  int? tempMax = 0;
  int? tempMin = 0;
  String? descripttion; //天気状態
  double? lon; //経度
  double? lat; //緯度
  String? icon; //天気アイコン
  DateTime? time; //日時
  int? rainyPercent; //降水確率

  Weather({
    this.temp,
    this.tempMax,
    this.tempMin,
    this.descripttion,
    this.lon,
    this.lat,
    this.icon,
    this.time,
    this.rainyPercent,
  });

  static Future<Weather?> getCurrentWether(String zipcode_) async {
    String zipCode  = '';
    if (zipcode_.contains('-')) {
      zipCode = zipcode_;
    } else {
      zipCode = '${zipcode_.substring(0, 3)}-${zipcode_.substring(3)}';
    }
    print(zipCode);
    String url = 'https://api.openweathermap.org/data/2.5/weather?zip=$zipCode,jp&appid=6aa145a1c87369884d49b25642de5da7&lang=ja&units=metric';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      print(data);
      if (data['cod'] != 200) {
        return Weather(descripttion: 'err',temp:0, tempMax: 0,tempMin: 0,);
      }
      Weather currentWeather = Weather(
        descripttion: data['weather'][0]['main'],
        temp: data['main']['temp'].toInt(),
        tempMax: data['main']['temp_max'].toInt(),
        tempMin: data['main']['temp_min'].toInt(),
      );
      return currentWeather;
    } catch (e) {
      print('err: $e');
      return null;
    }
  }
}
