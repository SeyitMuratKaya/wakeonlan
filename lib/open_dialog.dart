import 'package:flutter/material.dart';

Future<List<String>?> openDialog(
    context, message, nameController, ipController, macController) {
  final formKey = GlobalKey<FormState>();

  return showDialog<List<String>>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(message),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: ListBody(
            children: [
              TextFormField(
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Name field can not be empty";
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Device Name",
                  labelText: "Device Name",
                ),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Ip Address field can not be empty";
                  }
                  return null;
                },
                controller: ipController,
                decoration: const InputDecoration(
                  hintText: "Ip Address",
                  labelText: "Ip Address",
                ),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Mac Address field can not be empty";
                  }
                  return null;
                },
                controller: macController,
                decoration: const InputDecoration(
                  hintText: "Mac Address",
                  labelText: "Mac Address",
                ),
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              nameController.clear();
              ipController.clear();
              macController.clear();
            },
            child: const Text("Cancel")),
        ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop([
                  nameController.text.toString(),
                  ipController.text.toString(),
                  macController.text.toString()
                ]);
                nameController.clear();
                ipController.clear();
                macController.clear();
              }
            },
            child: const Text("Save")),
      ],
    ),
  );
}
