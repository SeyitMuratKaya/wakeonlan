import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test.json');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file

      String contents;
      try {
        contents = await file.readAsString();
      } catch (e) {
        contents = "[]";
      }

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "read error";
    }
  }

  Future<File> writeCounter(String test) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(test);
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
