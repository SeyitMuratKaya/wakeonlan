import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Item {
  String id = UniqueKey().toString();
  bool status = false;
  String name;
  String ipAdd;
  String macAdd;

  Item(this.name, this.ipAdd, this.macAdd);
}

List<String> scannedDevices = <String>[];

class AppTheme extends ChangeNotifier {
  late bool _customColorSelected;
  late bool _autoThemeModeSelected;
  late bool _darkModeSelected;
  late int _selectedColor;
  ThemeMode themeMode = ThemeMode.system;
  Color _color = Colors.blue;
  SharedPreferences? _prefs;

  bool get customColorSelected => _customColorSelected;
  bool get autoThemeModeSelected => _autoThemeModeSelected;
  bool get darkModeSelected => _darkModeSelected;
  int get selectedColor => _selectedColor;
  Color get color => _color;

  AppTheme() {
    _customColorSelected = false;
    _autoThemeModeSelected = true;
    _darkModeSelected = false;
    _selectedColor = 0;
    _loadprefs();
  }

  set customColorSelected(bool value) {
    _customColorSelected = value;
    _saveprefs();
    notifyListeners();
  }

  set autoThemeModeSelected(bool value) {
    _autoThemeModeSelected = value;
    themeMode = value
        ? ThemeMode.system
        : (_darkModeSelected ? ThemeMode.dark : ThemeMode.light);
    _saveprefs();
    notifyListeners();
  }

  set darkModeSelected(bool value) {
    _darkModeSelected = value;
    themeMode = value ? ThemeMode.dark : ThemeMode.light;
    _saveprefs();
    notifyListeners();
  }

  set selectedColor(int value) {
    _selectedColor = value;
    _saveprefs();
    notifyListeners();
  }

  set color(Color selectedColor) {
    _color = selectedColor;
    _saveprefs();
    notifyListeners();
  }

  _initiateprefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  _loadprefs() async {
    await _initiateprefs();
    customColorSelected = _prefs?.getBool("customColor") ?? false;
    darkModeSelected = _prefs?.getBool("darkMode") ?? false;
    autoThemeModeSelected = _prefs?.getBool("autoThemeMode") ?? true;
    selectedColor = _prefs?.getInt("selectedColor") ?? 0;
    color = Colors.primaries[selectedColor];
    notifyListeners();
  }

  _saveprefs() async {
    await _initiateprefs();
    _prefs?.setBool("customColor", _customColorSelected);
    _prefs?.setBool("autoThemeMode", _autoThemeModeSelected);
    _prefs?.setBool("darkMode", _darkModeSelected);
    _prefs?.setInt("selectedColor", _selectedColor);
  }
}

class InternetStatus extends ChangeNotifier {
  bool _status = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool get status => _status;

  set status(bool value) {
    _status = value;
    notifyListeners();
  }

  InternetStatus() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      debugPrint(e.toString());
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi) {
      _status = true;
    } else {
      _status = false;
    }
  }
}
