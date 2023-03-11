import 'package:flutter/material.dart';
import 'package:wakeonlan/file_manager.dart';
import 'package:wakeonlan/pages/devices_page.dart';
import 'package:wakeonlan/pages/network_page.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({super.key});

  static final _defaultLightColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue);

  static final _defaultDarkColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      return MaterialApp(
        title: 'WakeOnLan',
        theme: ThemeData(
          colorScheme: lightDynamic?.harmonized() ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic?.harmonized() ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const BottomNavigation(),
      );
    });
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
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
