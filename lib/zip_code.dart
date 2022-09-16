

import 'dart:convert';

import 'package:http/http.dart';

class ZipCode {
  static Future<String?> searchAddress(String zipcode) async {
    String url = 'https://zipcloud.ibsnet.co.jp/api/search?zipcode=$zipcode';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      String address = data['results'][0]['address2'];
      print('GetAddress:$address');
      return address;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }
}
