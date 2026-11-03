import 'dart:async';

import 'package:flutter/material.dart';

import '../models/smart_device.dart';
import '../models/smart_light.dart';
import '../models/smart_speaker.dart';
import '../models/thermostat.dart';
import '../widgets/device_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Duration _temperatureUpdateInterval = Duration(seconds: 3);

  // Created once so rebuilds do not inflate SmartDevice.totalDevices.
  late final List<SmartDevice> _devices = _createDevices();
  late final Timer _temperatureTimer;

  @override
  void initState() {
    super.initState();
    _temperatureTimer = Timer.periodic(
      _temperatureUpdateInterval,
      (_) => _updateRoomTemperatures(),
    );
  }

  @override
  void dispose() {
    _temperatureTimer.cancel();
    super.dispose();
  }

  void _updateRoomTemperatures() {
    setState(() {
      for (final thermostat in _devices.whereType<Thermostat>()) {
        thermostat.updateRoomTemperature();
      }
    });
  }

  List<SmartDevice> _createDevices() {
    final eveningTime = DateTime.now().copyWith(hour: 22, minute: 30);

    return [
      SmartLight('Living Room', isOn: true, brightness: 75),
      SmartLight.dimmed('Kitchen')..schedule(eveningTime),
      Thermostat('Bedroom', roomTemperature: 20),
      SmartSpeaker('Office', volume: 40),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Controller'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (final device in _devices)
            DeviceCard(device: device, onChanged: () => setState(() {})),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Total Devices: ${SmartDevice.totalDevices}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
