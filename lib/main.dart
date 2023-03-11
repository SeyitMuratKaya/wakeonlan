import 'package:flutter/material.dart';
import 'package:wakeonlan/file_manager.dart';
import 'package:wakeonlan/pages/devices_page.dart';
import 'package:wakeonlan/pages/network_page.dart';

void main() => runApp(
      MaterialApp(
        home: const ExampleApp(),
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0x00F2F2F2),
        ),
      ),
    );

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Devices',
          ),
          NavigationDestination(
            icon: Icon(Icons.computer),
            label: 'Network',
          ),
        ],
      ),
      body: <Widget>[
        DevicesPage(storage: FileManager()),
        const NetworkPage(),
      ][currentPageIndex],
    );
  }
}
