import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:provider/provider.dart';
import 'package:wakeonlan/file_manager.dart';
import 'package:wakeonlan/models/models.dart';
import 'package:wakeonlan/pages/devices_page.dart';
import 'package:wakeonlan/pages/network_page.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppTheme()),
      ],
      child: const Home(),
    ));

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);

    final defaultLightColorScheme = ColorScheme.fromSeed(
        seedColor: appTheme.customColorSelected ? appTheme.color : Colors.blue);

    final defaultDarkColorScheme = ColorScheme.fromSeed(
        seedColor: appTheme.customColorSelected ? appTheme.color : Colors.blue,
        brightness: Brightness.dark);

    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      return MaterialApp(
        title: 'WakeOnLan',
        theme: ThemeData(
          colorScheme: defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: defaultDarkColorScheme,
          useMaterial3: true,
        ),
        themeMode: appTheme.themeMode,
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
  void initState() {
    super.initState();
    scan();
  }

  Future<void> scan() async {
    final scanner = LanScanner();

    final stream =
        scanner.icmpScan('192.168.1', progressCallback: (progress) {});

    stream.listen((HostModel device) {
      debugPrint("Found host: ${device.ip}");
      setState(() {
        scannedDevices.add(device.ip);
      });
    });
  }

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
            icon: Icon(Icons.devices),
            label: 'Devices',
          ),
          NavigationDestination(
            icon: Icon(Icons.lan_outlined),
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
