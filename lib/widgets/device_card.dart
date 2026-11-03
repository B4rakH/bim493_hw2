import 'package:flutter/material.dart';

import '../models/schedulable.dart';
import '../models/smart_device.dart';
import '../models/smart_light.dart';
import '../models/smart_speaker.dart';
import '../models/thermostat.dart';

/// Shows one device's information and its type-specific control.
class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key, required this.device, required this.onChanged});

  final SmartDevice device;

  /// Called after the device state changes so the parent can rebuild.
  final VoidCallback onChanged;

  void _run(VoidCallback action) {
    action();
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final schedule = switch (device) {
      Schedulable(hasSchedule: true, :final scheduleInfo) => scheduleInfo,
      _ => null,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _DeviceIcon(device: device),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(device.title, style: textTheme.titleSmall),
                  Text(device.propertyLabel, style: textTheme.bodySmall),
                  _StatusLine(device: device),
                  if (schedule != null)
                    Text(schedule, style: textTheme.bodySmall),
                ],
              ),
            ),
            _buildControl(),
          ],
        ),
      ),
    );
  }

  Widget _buildControl() {
    return switch (device) {
      SmartLight light => Switch(
          value: light.isOn,
          onChanged: (_) => _run(light.performAction),
        ),
      Thermostat thermostat => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.outlined(
              tooltip: 'Decrease temperature',
              icon: const Icon(Icons.remove),
              onPressed: () => _run(thermostat.decreaseTemperature),
            ),
            IconButton.outlined(
              tooltip: 'Increase temperature',
              icon: const Icon(Icons.add),
              onPressed: () => _run(thermostat.increaseTemperature),
            ),
          ],
        ),
      SmartSpeaker speaker => IconButton.filled(
          tooltip: speaker.isPlaying ? 'Pause' : 'Play',
          icon: Icon(speaker.isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () => _run(speaker.performAction),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _DeviceIcon extends StatelessWidget {
  const _DeviceIcon({required this.device});

  final SmartDevice device;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (device) {
      SmartLight() => (Icons.lightbulb, Colors.amber),
      Thermostat() => (Icons.thermostat, Colors.deepOrange),
      SmartSpeaker() => (Icons.speaker, Colors.blue),
      _ => (Icons.devices_other, Colors.grey),
    };
    final activeColor = device.isActive ? color : Colors.grey;

    return CircleAvatar(
      backgroundColor: activeColor.withValues(alpha: 0.15),
      child: Icon(icon, color: activeColor),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.device});

  final SmartDevice device;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 8,
          color: device.isActive ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          'Status: ${device.getStatus()}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
