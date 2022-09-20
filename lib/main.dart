import 'package:flutter/material.dart';
import 'package:weather_forecast/provider/address_data.dart';
import 'package:weather_forecast/provider/weather_data.dart';
import 'package:weather_forecast/top_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<WeatherData>(
            create: (context) => WeatherData(),
            child: const TopPage(),
          ),
          ChangeNotifierProvider<AddressData>(
            create: (context) => AddressData(),
            child: const TopPage(),
          ),
        ],
        child: const TopPage(),
      )
    );
  }
}
