import 'package:flutter/material.dart';
import 'package:weather_forecast/provider/address_data.dart';
import 'package:weather_forecast/provider/weather_data.dart';
import 'package:weather_forecast/repository/weather.dart';
import 'package:weather_forecast/repository/zipcode.dart';
import 'package:provider/provider.dart';

class ZipCodeForm extends StatefulWidget {
  const ZipCodeForm({super.key});

  @override
  State<ZipCodeForm> createState() => _ZipCodeFormState();
}

class _ZipCodeFormState extends State<ZipCodeForm> {
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

  @override
  Widget build(BuildContext context) {
    final WeatherData data = Provider.of<WeatherData>(context);
    final AddressData addressData = Provider.of<AddressData>(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      color: Colors.blue.shade50,
      width: 200,
      child: TextField(
        onSubmitted: (value) async {
          Map<String, String>? found = await ZipCode.searchAddress(value) ?? {'message': 'error'};
          if (found.containsKey('address') == true) {
            var address = found['address'];
            addressData.setAddress(address!);
            var currentWeather = await Weather.getCurrentWether(value) ?? Weather(descripttion: 'err');
            if (currentWeather.descripttion == 'err') {
              _showSnackBarTop(title: found['message'] ?? 'CURRENT WEATHER ERROR', sec: 5);
            } else {
              var perHourWeather = await Weather.getHourlyWeathers(value);
              var dailyWeather = await Weather.getDailyWeathers(value);
              data.setNotify(currentWeather, perHourWeather!, dailyWeather!);
            }
          } else if (found.containsKey('message') == true) {
            _showSnackBarTop(title: found['message'] ?? 'found.containsKey ERROR', sec: 5);
          }
        },
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: '〒: 1234567',),
      ),
    );
  }
}
