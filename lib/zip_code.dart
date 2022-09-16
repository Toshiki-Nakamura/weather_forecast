

import 'dart:convert';

import 'package:http/http.dart';

class ZipCode {
  static Future<Map<String, String>?> searchAddress(String zipcode) async {
    String url = 'https://zipcloud.ibsnet.co.jp/api/search?zipcode=$zipcode';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      Map<String, String> response = {};
      if (data['message'] != null) {
        response['message'] = data['message'];
      } else if (data['results'] == null) {
        response['message'] = '郵便番号を確認してください';
      } else {
        String address = data['results'][0]['address2'];
        response['address'] = address; // print('GetAddress:$address');
      }
      return response;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }
}
