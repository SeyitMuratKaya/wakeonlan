import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakeonlan/file_manager.dart';
import './wol/wake_on_lan.dart';
import 'models/models.dart';
import 'open_dialog.dart';

class DeviceItem extends StatefulWidget {
  const DeviceItem({
    super.key,
    required this.item,
    required this.onConfirm,
  });

  final Item item;
  final Function(List<String> result) onConfirm;

  @override
  State<DeviceItem> createState() => _DeviceItemState();
}

class _DeviceItemState extends State<DeviceItem> {
  final nameController = TextEditingController();
  final ipController = TextEditingController();
  final macController = TextEditingController();

  final fileManager = FileManager();

  @override
  void dispose() {
    nameController.dispose();
    ipController.dispose();
    macController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    var snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void sendMagicPacket(String ipAdd, String macAdd) async {
    if (MACAddress.validate(macAdd) && IPv4Address.validate(ipAdd)) {
      MACAddress macAddress = MACAddress(macAdd);
      IPv4Address ipv4Address = IPv4Address(ipAdd);

      WakeOnLAN wol = WakeOnLAN(ipv4Address, macAddress);

      await wol.wake().then((value) => showMessage("Packet Sent!"));
    } else {
      showMessage("Unable To Send!");
    }
  }

  void displayDialog() async {
    nameController.text = widget.item.name;
    ipController.text = widget.item.ipAdd;
    macController.text = widget.item.macAdd;

    var result = await openDialog(
        context, "Edit Device", nameController, ipController, macController);
    if (result == null || result.isEmpty) return;

    result.add(widget.item.id);
    widget.onConfirm(result);
  }

  @override
  Widget build(BuildContext context) {
    final internetStatus = Provider.of<InternetStatus>(context);
    return Card(
      child: ListTile(
        onTap: () {
          //Wake the device
          String macAdd = widget.item.macAdd;
          String ipAdd = widget.item.ipAdd;
          if (internetStatus.status) {
            sendMagicPacket(ipAdd, macAdd);
          } else {
            showMessage("No Network Connection");
          }
        },
        leading: Badge(
          backgroundColor: widget.item.status ? Colors.green : Colors.red,
          child: CircleAvatar(
            child: Text(widget.item.name[0].toUpperCase()),
          ),
        ),
        title: Text(widget.item.name),
        subtitle: Text("${widget.item.ipAdd} - ${widget.item.macAdd}"),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: displayDialog,
        ),
      ),
    );
  }
}
