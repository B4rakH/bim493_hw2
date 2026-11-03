import 'package:bim493_hw2/models/smart_device.dart';
import 'package:bim493_hw2/models/smart_light.dart';
import 'package:bim493_hw2/models/smart_speaker.dart';
import 'package:bim493_hw2/models/thermostat.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every constructor increments the static device counter', () {
    final before = SmartDevice.totalDevices;

    SmartLight('Hall');
    SmartLight.dimmed('Hall');
    Thermostat.eco('Hall', roomTemperature: 20);
    SmartSpeaker.muted('Hall');

    expect(SmartDevice.totalDevices, before + 4);
  });

  test('light shows 0% brightness while off', () {
    final light = SmartLight('Hall', brightness: 80);
    expect(light.propertyLabel, 'Brightness: 0%');

    light.performAction();

    expect(light.getStatus(), 'ON');
    expect(light.propertyLabel, 'Brightness: 80%');
  });

  test('thermostat status follows target vs room temperature', () {
    final thermostat = Thermostat('Hall', roomTemperature: 21);
    expect(thermostat.getStatus(), 'Heating');

    thermostat.decreaseTemperature();
    expect(thermostat.getStatus(), 'Idle');

    thermostat.decreaseTemperature();
    expect(thermostat.getStatus(), 'Cooling');

    thermostat.performAction();
    expect(thermostat.getStatus(), 'OFF');
  });

  test('thermostat target stays within limits', () {
    final thermostat = Thermostat(
      'Hall',
      roomTemperature: 20,
      targetTemperature: Thermostat.maxTemperature,
    );

    thermostat.increaseTemperature();

    expect(thermostat.targetTemperature, Thermostat.maxTemperature);
  });

  test('speaker pauses when disconnected', () {
    final speaker = SmartSpeaker('Hall', isPlaying: true);

    speaker.disconnect();

    expect(speaker.isConnected, isFalse);
    expect(speaker.getStatus(), 'Paused');
  });
}
