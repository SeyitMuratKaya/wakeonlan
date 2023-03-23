import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: ElevatedButton(
        child: const Text("Back"),
        onPressed: () {
          Navigator.pop(context);
        },
      )),
    );
  }
}