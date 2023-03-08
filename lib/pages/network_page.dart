import 'package:flutter/material.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  final List<NetworkItem> computers = <NetworkItem>[
    const NetworkItem(
      name: "Computer 1",
      ipAdd: "192.168.1.5",
      macAdd: "38:f9:d3:a4:96:ab",
    ),
    const NetworkItem(
      name: "Computer 2",
      ipAdd: "192.168.1.7",
      macAdd: "0e:22:88:d6:97:e0",
    ),
  ];

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
              setState(() {
                computers.insert(
                    computers.length,
                    const NetworkItem(
                      name: "New Device",
                      ipAdd: "test",
                      macAdd: "test",
                    ));
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: computers.length,
        itemBuilder: (context, index) {
          return computers[index];
        },
      ),
    );
  }
}

class NetworkItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {},
        title: Text(name),
        subtitle: Text("$ipAdd - $macAdd"),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ),
    );
  }
}
