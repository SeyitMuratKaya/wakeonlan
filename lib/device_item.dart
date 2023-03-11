import 'package:flutter/material.dart';

final List<DeviceItem> myComputers = <DeviceItem>[];

class DeviceItem extends StatefulWidget {
  const DeviceItem({
    super.key,
    required this.name,
    required this.ipAdd,
    required this.macAdd,
  });

  final String name;
  final String ipAdd;
  final String macAdd;

  @override
  State<DeviceItem> createState() => _DeviceItemState();
}

class _DeviceItemState extends State<DeviceItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          //Wake the device
        },
        title: Text(widget.name),
        subtitle: Text("${widget.ipAdd} - ${widget.macAdd}"),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            //Edit information
          },
        ),
      ),
    );
  }
}
