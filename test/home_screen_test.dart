import 'package:bim493_hw2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home screen lists devices and reacts to controls', (
    tester,
  ) async {
    await tester.pumpWidget(const SmartHomeApp());

    expect(find.text('Smart Light: Living Room'), findsOneWidget);
    expect(find.text('Thermostat: Bedroom'), findsOneWidget);
    expect(find.text('Smart Speaker: Office'), findsOneWidget);
    expect(find.text('Total Devices: 4'), findsOneWidget);

    await tester.tap(find.byType(Switch).first);
    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pumpAndSettle();

    expect(find.text('Brightness: 0%'), findsOneWidget);
    expect(find.text('Temperature: 23°C (room 20°C)'), findsOneWidget);
    expect(find.text('Status: Playing'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Temperature: 23°C (room 21°C)'), findsOneWidget);
  });
}
