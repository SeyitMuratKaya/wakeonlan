import 'package:flutter/material.dart';
import './wol/wake_on_lan.dart';

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
  void showMessage(String message) {
    var snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          //Wake the device
          String mac = widget.macAdd;
          String ipv4 = widget.ipAdd;

          if (MACAddress.validate(mac) && IPv4Address.validate(ipv4)) {
            MACAddress macAddress = MACAddress(mac);
            IPv4Address ipv4Address = IPv4Address(ipv4);
            WakeOnLAN wol = WakeOnLAN(ipv4Address, macAddress);
            await wol.wake().then((value) => showMessage("Packet Sent!"));
          } else {
            showMessage("Unable To Send!");
          }
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
