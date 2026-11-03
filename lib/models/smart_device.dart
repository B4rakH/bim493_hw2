import 'connectable.dart';

/// Common base for every device in the home.
abstract class SmartDevice implements Connectable {
  static int _totalDevices = 0;

  static int get totalDevices => _totalDevices;

  final String name;
  bool isOn;
  bool _isConnected = true;

  SmartDevice(this.name, {this.isOn = false}) {
    _totalDevices++;
  }

  /// Human readable device type, e.g. "Smart Light".
  String get type;

  /// The main property of the device, e.g. "Brightness: 75%".
  String get propertyLabel;

  /// Current state shown to the user, e.g. "ON" or "Heating".
  String getStatus();

  /// The primary action triggered from the device's main control.
  void performAction();

  String get title => '$type: $name';

  /// Whether the device is currently doing its job; drives the status color.
  bool get isActive => isOn;

  @override
  bool get isConnected => _isConnected;

  @override
  void connect() => _isConnected = true;

  @override
  void disconnect() => _isConnected = false;
}
