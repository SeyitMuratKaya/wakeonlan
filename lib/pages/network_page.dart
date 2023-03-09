import 'package:flutter/material.dart';
import '../network_item.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Devices',
            onPressed: () {
              //search network
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: lanComputers.length,
        itemBuilder: (context, index) {
          return lanComputers[index];
        },
      ),
    );
  }
}
