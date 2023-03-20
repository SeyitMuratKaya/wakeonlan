import 'package:flutter/material.dart';

class Item {
  String id = UniqueKey().toString();
  bool status = false;
  String name;
  String ipAdd;
  String macAdd;

  Item(this.name, this.ipAdd, this.macAdd);
}

List<String> scannedDevices = <String>[];
