import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test1.json');
  }

  Future<String> readDevices() async {
    try {
      final file = await _localFile;

      String contents;

      try {
        contents = await file.readAsString();
      } catch (e) {
        contents = "[]";
      }

      return contents;
    } catch (e) {
      return "Read Error";
    }
  }

  Future<File> writeDevices(String devices) async {
    final file = await _localFile;

    return file.writeAsString(devices);
  }

  Future<int> deleteFile() async {
    try {
      final file = await _localFile;

      await file.delete();
      return 1;
    } catch (e) {
      return 0;
    }
  }
}

class Device {
  String? name;
  String? ip;
  String? mac;

  Device({this.name, this.ip, this.mac});

  Device.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ip = json['ip'];
    mac = json['mac'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['ip'] = ip;
    data['mac'] = mac;
    return data;
  }
}
