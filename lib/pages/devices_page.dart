import 'package:flutter/material.dart';
import '../device_item.dart';
import '../open_dialog.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

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
      body: ListView.builder(
        itemCount: myComputers.length,
        itemBuilder: (context, index) {
          return myComputers[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //save to local storage
          final result = await openDialog(
              context, nameController, ipController, macController);
          if (result == null || result.isEmpty) return;
          setState(() {
            myComputers.insert(
              myComputers.length,
              DeviceItem(
                name: result[0],
                ipAdd: result[1],
                macAdd: result[2],
              ),
            );
          });
        },
        tooltip: "Add Device",
        child: const Icon(Icons.add),
      ),
    );
  }
}
