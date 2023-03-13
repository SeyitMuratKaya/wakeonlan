import 'dart:io';
import 'package:convert/convert.dart';

class WakeOnLAN {
  static const _maxPort = 65535;
  final IPv4Address ipv4Address;
  final MACAddress macAddress;
  final int port;

  WakeOnLAN._internal(this.ipv4Address, this.macAddress, this.port);

  factory WakeOnLAN(
    IPv4Address ipv4,
    MACAddress mac, {
    int port = 9,
  }) {
    assert(port <= _maxPort);
    return WakeOnLAN._internal(ipv4, mac, port);
  }

  factory WakeOnLAN.fromString(
    String ipv4,
    String mac, {
    int port = 9,
  }) {
    assert(port <= _maxPort);
    return WakeOnLAN._internal(
      IPv4Address(ipv4),
      MACAddress(mac),
      port,
    );
  }

  List<int> magicPacket() {
    List<int> data = [];

    for (int i = 0; i < 6; i++) {
      data.add(0xFF);
    }
    for (int j = 0; j < 16; j++) {
      data.addAll(macAddress.bytes);
    }

    return data;
  }

  Future<void> wake() async {
    return RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
      final addr = ipv4Address.address;
      final iAddr = InternetAddress(addr, type: InternetAddressType.IPv4);

      socket.broadcastEnabled = true;
      socket.send(magicPacket(), iAddr, port);
      socket.close();
    });
  }
}

class MACAddress {
  final String address;
  final String delimiter;
  final List<int> bytes;

  MACAddress._internal(this.address, this.delimiter, this.bytes);

  factory MACAddress(
    String address, {
    String delimiter = ':',
  }) {
    if (!MACAddress.validate(address, delimiter: delimiter)) {
      throw const FormatException('Not a valid MAC address string');
    }

    List<String> split = address.split(delimiter);
    List<int> bytes = split.map((octet) => hex.decode(octet)[0]).toList();

    return MACAddress._internal(address, delimiter, bytes);
  }
  
  static bool validate(
    String? address, {
    String delimiter = ':',
  }) {
    if (address == null) return false;

    final delim = delimiter.split('').map((c) => '\\$c').toList().join();
    final regex = r'^([0-9A-Fa-f]{2}' + delim + r'){5}([0-9A-Fa-f]{2})$';
    RegExp exp = RegExp(regex);

    return exp.hasMatch(address);
  }
}

class IPv4Address {
  final String address;

  IPv4Address._internal(this.address);

  factory IPv4Address(String address) {
    if (!IPv4Address.validate(address)) {
      throw const FormatException('Not a valid IPv4 address string');
    }

    return IPv4Address._internal(address);
  }
  
  static bool validate(String? address) {
    if (address == null) return false;

    const regex = r"\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b";
    RegExp exp = RegExp(regex);

    return exp.hasMatch(address);
  }
}