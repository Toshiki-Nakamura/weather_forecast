import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/provider/address_data.dart';

import 'package:weather_forecast/widget/current_column.dart';
import 'package:weather_forecast/widget/daily_view.dart';
import 'package:weather_forecast/provider/weather_data.dart';
import 'package:weather_forecast/widget/hourly_view.dart';
import 'package:weather_forecast/repository/weather.dart';
import 'package:weather_forecast/repository/zipcode.dart';
import 'package:weather_forecast/widget/zipcode_form.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Future<List<dynamic>?>? initWeather;

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
    Weather currentWeather = Weather(descripttion: 'err');
    List<Weather> perHourWeather = [Weather(descripttion: 'err')];
    List<Weather> dailyWeather = [Weather(descripttion: 'err')];

    Map<String, String>? found = await ZipCode.searchAddress('1000005') ?? {'message': 'error'};
    if (found.containsKey('address') == true) {
      var address = found['address'] ?? 'ERROR';
      currentWeather = await Weather.getCurrentWether('1000005') ?? currentWeather;
      if (currentWeather.descripttion == 'err') {
        _showSnackBarTop(title: found['message'] ?? 'ERROR', sec: 5);
      } else {
        perHourWeather = await Weather.getHourlyWeathers('1000005') ?? perHourWeather;
        dailyWeather = await Weather.getDailyWeathers('1000005') ?? dailyWeather;
      }
      if (!mounted) {
        print('mouted is false');
        return null;
      }
      context.read<AddressData>().setAddress(address);
      context.read<WeatherData>().setNotify(currentWeather, perHourWeather, dailyWeather);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: initWeather, //futureを一回だけ呼びたい場合,initState()で初期化した変数を使う
        initialData: const [], // null?
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SafeArea(
              child: Column(
                children: [
                  const ZipCodeForm(),
                  const CurrentColumn(),
                  const HourlyView(),
                  DailyView(),
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
