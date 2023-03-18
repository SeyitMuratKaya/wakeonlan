import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';
import '../models/models.dart';
import '../network_item.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  final List<Item> lanComputers = <Item>[];
  double progressIndicator = 0.0;

  @override
  void initState() {
    setState(() {
      lanComputers.clear();
    });
    scan();
    super.initState();
  }

  Future<void> scan() async {
    final scanner = LanScanner();

    final stream = scanner.icmpScan('192.168.1', progressCallback: (progress) {
      // print('Progress: $progress');
      setState(() {
        progressIndicator = progress;
      });
    });

    stream.listen((HostModel device) {
      debugPrint("Found host: ${device.ip}");
      setState(() {
        lanComputers.add(Item("", device.ip, ""));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Network"),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 1.0),
          child: LinearProgressIndicator(value: progressIndicator),
        ),
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
          return NetworkItem(item: lanComputers[index]);
        },
      ),
    );
  }
}
