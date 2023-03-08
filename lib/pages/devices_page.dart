import 'package:flutter/material.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

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
          )
        ],
      ),
      body: ListView(
        children: const [
          Card(child: ListTile(title: Text("Device 1"))),
          Card(child: ListTile(title: Text("Device 2"))),
          Card(child: ListTile(title: Text("Device 3"))),
        ],
      ),
    );
  }
}
