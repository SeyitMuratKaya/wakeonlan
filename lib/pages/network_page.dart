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
  bool scanState = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> scan() async {
    if (scanState) return;

    setState(() {
      lanComputers.clear();
      scanState = true;
    });

    final scanner = LanScanner();

    final stream = scanner.icmpScan('192.168.1', progressCallback: (progress) {
      setState(() {
        progressIndicator = progress;
        if (progress == 1.0) {
          scanState = false;
        }
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
          child: Visibility(
              visible: scanState,
              child: LinearProgressIndicator(value: progressIndicator)),
        ),
        actions: [
          Visibility(
            visible: lanComputers.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Devices',
              onPressed: scan,
            ),
          ),
        ],
      ),
      body: lanComputers.isEmpty
          ? Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.height / 4,
                height: MediaQuery.of(context).size.width / 4,
                child: ElevatedButton(
                  onPressed: scan,
                  child: const Text(
                    "Scan",
                    textScaleFactor: 2,
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: lanComputers.length,
              itemBuilder: (context, index) {
                return NetworkItem(item: lanComputers[index]);
              },
            ),
    );
  }
}
