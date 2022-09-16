import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/weather.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Weather currentWeather = Weather(temp: 18, descripttion: '晴れ', tempMax: 22, tempMin: 14);

  List<Weather> perHourWeather = List.generate(14, (i) => 
    Weather(temp: 15+i,descripttion: '晴れ',tempMax: 22,tempMin: 14,time: DateTime(2022,9,16,8+(i*2)),rainyPercent: 0)
  );

  List<Weather> dailyWeather = List.generate(7, (i) => 
    Weather(temp: 20, descripttion: '晴れ',tempMax: 22-i, tempMin: 14, time: DateTime(2022, 9, 16 + i), rainyPercent: 0)
  );

  List<String> weekDay = ['月','火', '水', '木', '金', '土', '日'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text('大阪市', style: TextStyle(fontSize: 25)),
          Text(currentWeather.descripttion ?? 'No'),
          Text('${currentWeather.temp ?? 0}°',
              style: const TextStyle(fontSize: 80)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('最高:${currentWeather.tempMax}°'),
              const SizedBox(
                width: 6,
              ),
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
                      const Icon(Icons.wb_sunny_sharp),
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
                            const Icon(Icons.wb_sunny_sharp),
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
    ));
  }
}



//todo 天気クラス作成 => done
//todo 現在の天気情報を表示 => done
//todo 1時間ごとの天気を表示=> done
//todo 日每の天気を表示 => done

//todo 郵便番号検索窓のUI作成


//todo 郵便番号から住所を取得
//todo 郵便番号檢索APIをdartで実施
//todo 檢索時に郵便番号から住所を取得•表示
//todo 検索欄への入力内容に間違いがある際にエラーを表示
//todo 現在の天気情報を取得
//todo 現在の天気情報をdartで取得
//todo 取得した情報から現在の天気情報を表示
//todo 1時間ごとの天気情報を取得
//todo 取得した情報から1時間ごとの天気情報を表示
//todo 日每の天気情報を取得
//todo 取得した情報から日每の天気情報を表示
