import 'schedulable.dart';
import 'smart_device.dart';

class Thermostat extends SmartDevice with Schedulable {
  static const int minTemperature = 10;
  static const int maxTemperature = 30;
  static const int ecoTemperature = 18;

  final int roomTemperature;
  int targetTemperature;

  Thermostat(
    super.name, {
    required this.roomTemperature,
    this.targetTemperature = 22,
  }) : super(isOn: true);

  Thermostat.eco(String name, {required int roomTemperature})
      : this(
          name,
          roomTemperature: roomTemperature,
          targetTemperature: ecoTemperature,
        );

  @override
  String get type => 'Thermostat';

  @override
  String get propertyLabel =>
      'Temperature: $targetTemperature°C (room $roomTemperature°C)';

  @override
  String getStatus() {
    if (!isOn) return 'OFF';
    if (targetTemperature > roomTemperature) return 'Heating';
    if (targetTemperature < roomTemperature) return 'Cooling';
    return 'Idle';
  }

  @override
  bool get isActive => super.isActive && getStatus() != 'Idle';

  @override
  void performAction() => isOn = !isOn;

  void increaseTemperature() => _setTarget(targetTemperature + 1);

  void decreaseTemperature() => _setTarget(targetTemperature - 1);

  void _setTarget(int value) {
    targetTemperature = value.clamp(minTemperature, maxTemperature);
  }
}
