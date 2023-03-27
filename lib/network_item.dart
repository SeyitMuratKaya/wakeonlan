import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wakeonlan/file_manager.dart';
import 'models/models.dart';
import 'open_dialog.dart';

class NetworkItem extends StatefulWidget {
  const NetworkItem({
    super.key,
    required this.item,
  });

  final Item item;

  @override
  State<NetworkItem> createState() => _NetworkItemState();
}

class _NetworkItemState extends State<NetworkItem> {
  final nameController = TextEditingController();
  final ipController = TextEditingController();
  final macController = TextEditingController();

  FileManager fileManager = FileManager();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    ipController.dispose();
    macController.dispose();
    super.dispose();
  }

  void _addDevice(List<String> result) {
    fileManager.readDevices().then((value) {
      Device newDevice = Device(name: result[0], ip: result[1], mac: result[2]);
      List<dynamic> allDevices = jsonDecode(value);

      allDevices.add(newDevice);

      String allDevicesJson = jsonEncode(allDevices);

      fileManager.writeDevices(allDevicesJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          nameController.text = "";
          ipController.text = widget.item.ipAdd;
          macController.text = "";
          final result = await openDialog(context, "Add Device", nameController,
              ipController, macController);
          if (result == null || result.isEmpty) return;
          // Save to local storage
          _addDevice(result);
        },
        title: Text(widget.item.ipAdd),
      ),
    );
  }
}
