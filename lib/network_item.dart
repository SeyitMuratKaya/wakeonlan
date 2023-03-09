import 'package:flutter/material.dart';
import 'open_dialog.dart';

final List<NetworkItem> lanComputers = <NetworkItem>[
  const NetworkItem(
    name: "Lan Computer 1",
    ipAdd: "192.168.1.5",
    macAdd: "38:f9:d3:a4:96:ab",
  ),
  const NetworkItem(
    name: "Lan Computer 2",
    ipAdd: "192.168.1.7",
    macAdd: "0e:22:88:d6:97:e0",
  ),
];

class NetworkItem extends StatefulWidget {
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
  State<NetworkItem> createState() => _NetworkItemState();
}

class _NetworkItemState extends State<NetworkItem> {
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
    return Card(
      child: ListTile(
        onTap: () async {
          nameController.text = widget.name;
          ipController.text = widget.ipAdd;
          macController.text = widget.macAdd;
          final result = await openDialog(
              context, nameController, ipController, macController);
          if (result == null || result.isEmpty) return;
          // Save to local storage
        },
        title: Text(widget.name),
        subtitle: Text("${widget.ipAdd} - ${widget.macAdd}"),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ),
    );
  }
}
