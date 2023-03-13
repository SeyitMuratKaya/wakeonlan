import 'package:flutter/material.dart';
import 'package:wakeonlan/file_manager.dart';
import 'dart:convert';
import '../device_item.dart';
import '../open_dialog.dart';
import 'dart:ui';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key, required this.storage});

  final FileManager storage;

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final nameController = TextEditingController();
  final ipController = TextEditingController();
  final macController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    ipController.dispose();
    macController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        _devices = value;
        List<dynamic> allDevices = jsonDecode(_devices);
        setState(() {
          myComputers.clear();
          for (var element in allDevices) {
            myComputers.add(DeviceItem(
                name: element["name"],
                ipAdd: element["ip"],
                macAdd: element["mac"]));
          }
        });
        debugPrint("All devices $_devices");
      });
    });
  }

  String _devices = "";

  void _deleteDevices(int index) {
    setState(() {
      if (myComputers.isNotEmpty) myComputers.removeAt(index);
    });
    widget.storage.readCounter().then((value) {
      List<dynamic> devices = jsonDecode(value);
      devices.removeAt(index);
      String newList = jsonEncode(devices);
      widget.storage.writeCounter(newList);
      _devices = newList;
    });
  }

  void _addDevice(List<String> result, int index) {
    Device newDevice = Device(name: result[0], ip: result[1], mac: result[2]);

    List<dynamic> allDevices = jsonDecode(_devices);

    allDevices.insert(index, newDevice);

    String allDevicesJson = jsonEncode(allDevices);

    widget.storage.writeCounter(allDevicesJson);

    widget.storage.readCounter().then((value) {
      List<dynamic> devices = jsonDecode(value);
      setState(() {
        myComputers.clear();
        for (var element in devices) {
          myComputers.add(DeviceItem(
              name: element["name"],
              ipAdd: element["ip"],
              macAdd: element["mac"]));
        }
      });
    });

    _devices = allDevicesJson;
  }

  void _showSnackbar(String message, int index, List<String> result) {
    var snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            _addDevice(result, index);
          }),
    );
    _deleteDevices(index);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _reorderDevices(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    List<dynamic> allDevices = jsonDecode(_devices);

    final draggedDevice = allDevices.removeAt(oldIndex);
    allDevices.insert(newIndex, draggedDevice);
    String allDevicesJson = jsonEncode(allDevices);
    widget.storage.writeCounter(allDevicesJson);

    _devices = allDevicesJson;

    setState(() {
      final draggedItem = myComputers.removeAt(oldIndex);
      myComputers.insert(newIndex, draggedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Devices"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Devices',
            onPressed: () {},
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: myComputers.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey<DeviceItem>(myComputers[index]),
            background: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [Icon(Icons.delete)]),
              ),
            ),
            onDismissed: (DismissDirection direction) {
              _showSnackbar("Deleted", index, [
                myComputers[index].name,
                myComputers[index].ipAdd,
                myComputers[index].macAdd
              ]);
            },
            child: myComputers[index],
          );
        },
        onReorder: _reorderDevices,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //save to local storage
          final result = await openDialog(
              context, nameController, ipController, macController);
          if (result == null || result.isEmpty) return;
          _addDevice(result, myComputers.length);
        },
        tooltip: "Add Device",
        child: const Icon(Icons.add),
      ),
    );
  }
}
