import 'package:flutter/material.dart';
import 'package:weather_forecast/data.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<Data>(
        create: (context) => Data(),
        child: const TopPage(),
      ),
    );
  }
}
