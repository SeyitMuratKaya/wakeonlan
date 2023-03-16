import 'package:flutter/material.dart';

Future<List<String>?> openDialog(
        context, message, nameController, ipController, macController) =>
    showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Device Name",
                  labelText: "Device Name",
                ),
              ),
              TextField(
                controller: ipController,
                decoration: const InputDecoration(
                  hintText: "Ip Address",
                  labelText: "Ip Address",
                ),
              ),
              TextField(
                controller: macController,
                decoration: const InputDecoration(
                  hintText: "Mac Address",
                  labelText: "Mac Address",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop([
                  nameController.text.toString(),
                  ipController.text.toString(),
                  macController.text.toString()
                ]);
                nameController.clear();
                ipController.clear();
                macController.clear();
              },
              child: const Text("Save")),
        ],
      ),
    );
