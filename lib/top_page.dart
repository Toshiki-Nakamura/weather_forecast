import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/weather.dart';
import 'package:weather_forecast/zip_code.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Weather currentWeather = Weather(temp: 18, descripttion: '晴れ', tempMax: 22, tempMin: 14);

  List<Weather> perHourWeather = List.generate(15, (i) => 
    Weather(temp: 15+i,descripttion: '晴れ',tempMax: 22,tempMin: 14,time: DateTime(2022,9,16,8+(i*2)),rainyPercent: 0)
  );

  List<Weather> dailyWeather = List.generate(7, (i) => 
    Weather(temp: 20, descripttion: '晴れ',tempMax: 22-i, tempMin: 14, time: DateTime(2022, 9, 16 + i), rainyPercent: 0)
  );

  List<String> weekDay = ['月','火', '水', '木', '金', '土', '日'];

  Map<String, Icon> WeatherIcons = {
    '晴れ': const Icon(Icons.wb_sunny_sharp, color: Colors.orange),
    '雨': const Icon(CupertinoIcons.cloud_rain, color: Colors.blue),
    '曇り': const Icon(Icons.wb_cloudy_sharp, color: Colors.grey),
  };

  String? address;
  @override
  void initState() {
    // Future(() async {
    //   address = await ZipCode.searchAddress('5770844');
    //   print(address);
    // });
    address = '大阪市';
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
          bottom: MediaQuery.of(context).size.height - 120,
          right: 40,
          left: 40
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              color: Colors.blue.shade50,
              width: 200,
              child: TextField(
                onSubmitted: (value) async {
                  Map<String, String>? found = await ZipCode.searchAddress(value) ?? {'message': 'error'};
                  if (found.containsKey('address') == true) {
                    address = found['address'];
                    currentWeather = await Weather.getCurrentWether(value) ?? Weather(descripttion: 'err');
                    setState(() {});
                  } else if (found.containsKey('message') == true) {
                    _showSnackBarTop(title: found['message'] ?? 'ERROR', sec: 5);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '〒: 1234567',
                ),
              ),
            ),
            const SizedBox(height: 50),
            Text('$address', style: const TextStyle(fontSize: 25)),
            Text(currentWeather.descripttion ?? 'No'),
            Text('${currentWeather.temp ?? 0}°',
                style: const TextStyle(fontSize: 80)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('最高:${currentWeather.tempMax}°'),
                const SizedBox(width: 6,),
                Text('最低:${currentWeather.tempMin}°'),
              ],
            ),
            const SizedBox(height: 50),
            const Divider(height: 0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: perHourWeather.map((weather) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Column(
                      children: [
                        Text('${DateFormat('H').format(weather.time!)}時'),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text('${weather.rainyPercent}%', style: const TextStyle(color: Colors.blue),),
                        ),
                        WeatherIcons[weather.descripttion] ?? const Icon(CupertinoIcons.snow),
                        Padding(padding: const EdgeInsets.only(top: 8), child: Text('${weather.temp}'),),
                      ]
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: dailyWeather.map((weather) {
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
                              WeatherIcons[weather.descripttion] ?? const Icon(CupertinoIcons.snow),
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
            ),
          ],
        ),
      )
    );
  }
}

//todo 1時間ごとの天気情報を取得
//todo 取得した情報から1時間ごとの天気情報を表示
//todo 日每の天気情報を取得
//todo 取得した情報から日每の天気情報を表示
