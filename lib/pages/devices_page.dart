import 'package:flutter/material.dart';
import 'package:wakeonlan/file_manager.dart';
import 'dart:convert';
import 'dart:async';
import '../device_item.dart';
import '../models/models.dart';
import '../open_dialog.dart';
import './settings_page.dart';

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
  final List<Item> myComputers = <Item>[];
  String _devices = "";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _refresh();
    _checkDeviceStatus();
    timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => _checkDeviceStatus());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    ipController.dispose();
    macController.dispose();
    super.dispose();
    timer?.cancel();
  }

  void _addDevice(List<String> result, int index) {
    Device newDevice = Device(name: result[0], ip: result[1], mac: result[2]);

    List<dynamic> allDevices = jsonDecode(_devices);

    allDevices.insert(index, newDevice);

    _saveToLocal(allDevices);

    _refresh();
  }

  void _deleteDevices(int index) {
    setState(() {
      if (myComputers.isNotEmpty) myComputers.removeAt(index);
    });

    List<dynamic> allDevices = jsonDecode(_devices);

    allDevices.removeAt(index);

    _saveToLocal(allDevices);
  }

  void _reorderDevices(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    List<dynamic> allDevices = jsonDecode(_devices);

    final draggedDevice = allDevices.removeAt(oldIndex);
    allDevices.insert(newIndex, draggedDevice);

    _saveToLocal(allDevices);

    setState(() {
      final draggedItem = myComputers.removeAt(oldIndex);
      myComputers.insert(newIndex, draggedItem);
    });
  }

  void _editDevice(List<String> result) {
    var resultIndex =
        myComputers.indexWhere((element) => element.id == result[3]);

    List<dynamic> allDevices = jsonDecode(_devices);

    final editedDevice = allDevices.removeAt(resultIndex);

    editedDevice["name"] = result[0];
    editedDevice["ip"] = result[1];
    editedDevice["mac"] = result[2];

    allDevices.insert(resultIndex, editedDevice);

    _saveToLocal(allDevices);

    _refresh();
  }

  Future<void> _refresh() async {
    widget.storage.readDevices().then((value) {
      List<dynamic> allDevices = jsonDecode(value);
      setState(() {
        _devices = value;
        myComputers.clear();
        for (var element in allDevices) {
          myComputers.add(Item(element["name"], element["ip"], element["mac"]));
        }
      });
      debugPrint("Refreshed $_devices");
    });
  }

  void _saveToLocal(List<dynamic> allDevices) {
    String allDevicesJson = jsonEncode(allDevices);
    widget.storage.writeDevices(allDevicesJson);
    _devices = allDevicesJson;
  }

  void _checkDeviceStatus() {
    for (var element in myComputers) {
      if (scannedDevices.contains(element.ipAdd)) {
        setState(() {
          element.status = true;
        });
      }
    }
  }

  void _showSnackbar(String message, int index, List<String> result) {
    var snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Devices"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FirstPage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ReorderableListView.builder(
          itemCount: myComputers.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey<Item>(myComputers[index]),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                child: const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Icon(Icons.delete)]),
                ),
              ),
              onDismissed: (DismissDirection direction) {
                _showSnackbar("Deleted", index, [
                  myComputers[index].name,
                  myComputers[index].ipAdd,
                  myComputers[index].macAdd
                ]);
              },
              child: DeviceItem(
                item: myComputers[index],
                onConfirm: (result) {
                  _editDevice(result);
                },
              ),
            );
          },
          onReorder: _reorderDevices,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //save to local storage
          final result = await openDialog(context, "Add Device", nameController,
              ipController, macController);
          if (result == null || result.isEmpty) return;
          _addDevice(result, myComputers.length);
        },
        tooltip: "Add Device",
        child: const Icon(Icons.add),
      ),
    );
  }
}
