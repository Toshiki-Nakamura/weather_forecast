import 'package:flutter/material.dart';

class AddressData extends ChangeNotifier {
  String? address = 'NO DATA';

  setAddress(String newAddress) {
    address = newAddress;
    notifyListeners();
  }
}
