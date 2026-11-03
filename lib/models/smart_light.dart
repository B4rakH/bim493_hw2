import 'schedulable.dart';
import 'smart_device.dart';

class SmartLight extends SmartDevice with Schedulable {
  static const int dimmedBrightness = 30;

  final int brightness;

  SmartLight(super.name, {super.isOn, this.brightness = 100});

  SmartLight.dimmed(String name)
      : this(name, isOn: true, brightness: dimmedBrightness);

  @override
  String get type => 'Smart Light';

  @override
  String get propertyLabel => 'Brightness: ${isOn ? brightness : 0}%';

  @override
  String getStatus() => isOn ? 'ON' : 'OFF';

  @override
  void performAction() => isOn = !isOn;
}
