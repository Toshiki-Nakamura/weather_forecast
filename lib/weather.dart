import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

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

  static String apiKey = '6aa145a1c87369884d49b25642de5da7&lang=ja&units=metric';

  static String convertZipCode(String zipcode_) {
    String zipCode  = '';
    if (zipcode_.contains('-')) {
      zipCode = zipcode_;
    } else {
      zipCode = '${zipcode_.substring(0, 3)}-${zipcode_.substring(3)}';
    }
    return zipCode;
  }


  static Future<Weather?> getCurrentWether(String zipcode_) async {
    String zipCode  = convertZipCode(zipcode_);
    // print(zipCode);
    String url = 'https://api.openweathermap.org/data/2.5/weather?zip=$zipCode,jp&appid=$apiKey';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      // print(data);
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
      // print('err: $e');
      return null;
    }
  }

  static Future<List<Weather>?> getHourlyWeathers(String zipcode_) async {
    int size = 12;
    var zipCode = convertZipCode(zipcode_);
    String url = 'https://api.openweathermap.org/data/2.5/forecast?zip=$zipCode,jp&cnt=$size&appid=$apiKey';
    List<Weather> weathers = [];

    try
    {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        return weathers;
      }
      var dateFormatter = DateFormat("y-M-d HH:mm:ss");
      List<dynamic> list = data['list'];
      List<Weather> weatherList = list.map((value) {
        return Weather(
          descripttion: value['weather'][0]['main'],
          temp: value['main']['temp'].toInt(),
          time: dateFormatter.parseStrict(value['dt_txt']), // "dt_txt": "2022-09-17 06:00:00"
          rainyPercent: (((value['pop'] * 100)) / 10.0).round().toInt() * 10,
          icon: value['weather'][0]['icon'].toString(),
        );
      }).toList();
      return weatherList;
    }
    catch (e)
    {
      print('Execption: \x1B[33m$e\x1B[0m');
      return null;
    }
  }

  static Future<List<Weather>?> getDailyWeathers(String zipcode_) async {
    var zipCode = convertZipCode(zipcode_);
    String url = 'https://api.openweathermap.org/data/2.5/forecast?zip=$zipCode,jp&appid=$apiKey';
    List<Weather> weathers = [];
    DateTime next =  DateTime.now().add(const Duration(days: 1));
    DateFormat dateFormatter = DateFormat("y-M-d HH:mm:ss");
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        return weathers;
      }
      List<dynamic> list = data['list'];
      List<Weather>? weatherList = list.map((value) {
        DateTime date =  dateFormatter.parseStrict(value['dt_txt']);
        var weather = Weather(
            descripttion: value['weather'][0]['main'],
            temp: value['main']['temp'].toInt(),
            tempMax: value['main']['temp_max'].toInt(),
            tempMin: value['main']['temp_min'].toInt(),
            time: date,
            rainyPercent: (((value['pop'] * 100)) / 10.0).round().toInt() * 10,
            icon: value['weather'][0]['icon'].toString(),
        );
        if (date.difference(next).inDays == 0 && date.hour == 15) {
          next = date.add(const Duration(days: 1));
          return weather;
        }
        return Weather(descripttion: null);
      }).where((element) => element.descripttion != null).toList();
      return weatherList;
    } catch (e) {
      print('Execption: \x1B[33m$e\x1B[0m');
      return null;
    }
  }
}
