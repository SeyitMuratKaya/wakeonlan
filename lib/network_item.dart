import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wakeonlan/file_manager.dart';
import 'device_item.dart';
import 'open_dialog.dart';

final List<NetworkItem> lanComputers = <NetworkItem>[
  const NetworkItem(
    name: "Lan Computer 1",
    ipAdd: "192.168.1.5",
    macAdd: "38:f9:d3:a4:96:ab",
  ),
  const NetworkItem(
    name: "Lan Computer 2",
    ipAdd: "192.168.1.7",
    macAdd: "0e:22:88:d6:97:e0",
  ),
];

class NetworkItem extends StatefulWidget {
  const NetworkItem({
    super.key,
    required this.name,
    required this.ipAdd,
    required this.macAdd,
  });

  final String name;
  final String ipAdd;
  final String macAdd;

  @override
  State<NetworkItem> createState() => _NetworkItemState();
}

class _NetworkItemState extends State<NetworkItem> {
  final nameController = TextEditingController();
  final ipController = TextEditingController();
  final macController = TextEditingController();

  FileManager fileManager = FileManager();

  void _addDevice(List<String> result) {
    fileManager.readCounter().then((value) {
      Device newDevice = Device(name: result[0], ip: result[1], mac: result[2]);
      List<dynamic> allDevices = jsonDecode(value);

      allDevices.add(newDevice);

      String allDevicesJson = jsonEncode(allDevices);

      fileManager.writeCounter(allDevicesJson);

      setState(() {
        myComputers.clear();
        for (var element in allDevices) {
          myComputers.add(DeviceItem(
              name: element["name"],
              ipAdd: element["ip"],
              macAdd: element["mac"]));
        }
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    ipController.dispose();
    macController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          nameController.text = widget.name;
          ipController.text = widget.ipAdd;
          macController.text = widget.macAdd;
          final result = await openDialog(
              context, nameController, ipController, macController);
          if (result == null || result.isEmpty) return;
          // Save to local storage
          // TODO: crash _addDevice(result);
        },
        title: Text(widget.name),
        subtitle: Text("${widget.ipAdd} - ${widget.macAdd}"),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ),
    );
  }
}
