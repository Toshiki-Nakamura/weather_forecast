import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_forecast/current_data.dart';
import 'package:weather_forecast/daily_data.dart';
import 'package:weather_forecast/data.dart';
import 'package:weather_forecast/hourly_data.dart';
import 'package:weather_forecast/weather.dart';
import 'package:weather_forecast/zip_code.dart';
import 'package:weather_forecast/input_form.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Future<List<dynamic>?>? initWeather;
  Data data = Data();

  @override
  void initState() {
    // https://stackoverflow.com/questions/56424828/infinite-loop-on-using-futurebuilder-with-api-call
    initWeather = setApiStatus();
    super.initState();
  }

  void  _showSnackBarTop({required String title, int sec = 2}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: sec),
        content: Text(title),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepOrange.withOpacity(0.4),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 220,
          right: 40,
          left: 40
        ),
      ),
    );
  }

  Future<List<dynamic>?> setApiStatus() async {
    Map<String, String>? found = await ZipCode.searchAddress('1000005') ?? {'message': 'error'};
    if (found.containsKey('address') == true) {
      var address = found['address'] ?? 'ERROR';
      var currentWeather = await Weather.getCurrentWether('1000005') ?? Weather(descripttion: 'err');
      if (currentWeather.descripttion == 'err') {
        _showSnackBarTop(title: found['message'] ?? 'ERROR', sec: 5);
      } else {
        var perHourWeather = await Weather.getHourlyWeathers('1000005') ?? [Weather(descripttion: 'err')];
        var dailyWeather = await Weather.getDailyWeathers('1000005') ?? [Weather(descripttion: 'err')];
        data.setNotify(address, currentWeather, perHourWeather, dailyWeather);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    data = Provider.of<Data>(context);
    return Scaffold(
      body: FutureBuilder(
        future: initWeather, //futureを一回だけ呼びたい場合,initState()で初期化した変数を使う
        initialData: const [], // null?
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SafeArea(
              child: Column(
                children: [
                  const Input(),
                  const CurrentData(),
                  const HourlyData(),
                  DailyData(),
                ],
              ),
            );
          }
          return const CircularProgressIndicator();
        }
      ),
    );
  }
}
