import 'package:flutter/material.dart';
import 'package:wakeonlan/pages/devices_page.dart';
import 'package:wakeonlan/pages/network_page.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const NavigationExample(),
      theme: ThemeData(
          useMaterial3: true, colorSchemeSeed: const Color(0x00F2F2F2)),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
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
        const DevicesPage(),
        const NetworkPage(),
      ][currentPageIndex],
    );
  }
}
