import 'smart_device.dart';

class SmartSpeaker extends SmartDevice {
  final int volume;
  bool isPlaying;

  SmartSpeaker(super.name, {this.volume = 50, this.isPlaying = false})
      : super(isOn: true);

  SmartSpeaker.muted(String name) : this(name, volume: 0);

  @override
  String get type => 'Smart Speaker';

  @override
  String get propertyLabel => 'Volume: $volume%';

  @override
  String getStatus() => isPlaying ? 'Playing' : 'Paused';

  @override
  bool get isActive => isPlaying;

  @override
  void performAction() => isPlaying = !isPlaying;

  @override
  void disconnect() {
    super.disconnect();
    isPlaying = false;
  }
}
