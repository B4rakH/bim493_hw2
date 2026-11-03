# Smart Home Controller
**BIM493 - Mobile Programming I | Assignment #2**

A Flutter mobile application that lets users view and control smart home devices: turning lights on/off, adjusting a thermostat's target temperature and playing/pausing a speaker. Every device is modeled with object-oriented Dart, using an abstract base class, inheritance, an interface, a mixin, and the `static`, `super`, and `this` keywords.

---

## Team Information & Contributions

| Member Name | Student ID | Contribution |
| :--- | :--- | :--- |
| **Burak Haşimoğlu** | `50206821060` | State management architecture, navigation structure, details screen, and confirmation dialogs. |
| **Ahmet Melih Bulut** | `57844176248` | Reusable UI widgets, search & category filtering, asset management, and test suite verification. |


---

## Required Flutter Version

This project was built and validated on **Flutter 3.47.6** on the **Stable channel**

---

## Setup & Running the Application

### Prerequisites
- Flutter SDK `3.47.6` installed on the `stable` channel.
- An active emulator, simulator, or connected physical device.

### Setup Commands
1. Clone the repository and navigate into the project directory:
   ```bash
   git clone https://github.com/B4rakH/bim493_hw2.git
   cd bim493_hw2
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run static analysis (expected: 0 issues):
   ```bash
   flutter analyze
   ```
4. Run the automated test suite:
   ```bash
   flutter test
   ```
5. Launch the application:
   ```bash
   flutter run
   ```

---

## Project Structure

```
bim493_hw2/
├── lib/
│   ├── models/
│   │   ├── connectable.dart      # Connectable interface (connect, disconnect, isConnected)
│   │   ├── schedulable.dart      # Schedulable mixin (schedule, cancelSchedule, scheduleInfo)
│   │   ├── smart_device.dart     # Abstract SmartDevice base class with the static device counter
│   │   ├── smart_light.dart      # SmartLight: brightness, on/off switch
│   │   ├── thermostat.dart       # Thermostat: target/room temperature, Heating/Cooling/Idle
│   │   └── smart_speaker.dart    # SmartSpeaker: volume, play/pause
│   ├── screens/
│   │   └── home_screen.dart      # Device list and "Total Devices" bottom text
│   ├── widgets/
│   │   └── device_card.dart      # Card with device info, status dot and type-specific control
│   └── main.dart                 # Application entry point
├── test/
│   ├── models_test.dart          # 5 model tests
│   └── home_screen_test.dart     # 1 widget test for the home screen controls
├── pubspec.yaml
└── README.md
```

---

## Features & Implementation Overview

1. **Object-Oriented Device Model:**

   | Concept | Implementation |
   | :--- | :--- |
   | **Class** | Base class `SmartDevice` and subclasses `SmartLight`, `Thermostat`, `SmartSpeaker`. |
   | **Objects** | Four devices (two lights, a thermostat, a speaker) created once in `home_screen.dart`. |
   | **Constructor** | Default constructors (`SmartLight('Living Room', ...)`) and named constructors (`SmartLight.dimmed`, `Thermostat.eco`, `SmartSpeaker.muted`). |
   | **Inheritance** | All three device classes `extend SmartDevice`. |
   | **Abstraction** | `SmartDevice` is `abstract` with abstract `getStatus()` and `performAction()` methods. |
   | **Interface** | `Connectable` is implemented by `SmartDevice`, so every device class is `Connectable`. |
   | **Mixin** | `Schedulable` is used by `SmartLight` and `Thermostat`. |
   | **`static`** | Private `_totalDevices` counter exposed through `SmartDevice.totalDevices`, plus constants such as `Thermostat.maxTemperature`. |
   | **`super`** | Super parameters (`super.name`), `super(isOn: true)`, `super.isActive` in `Thermostat`, `super.disconnect()` in `SmartSpeaker`. |
   | **`this`** | Constructor field initialisers (`this.name`, `this.brightness`) and redirecting named constructors (`: this(...)`). |

2. **Device List & Device Cards:**
   - Each card shows the device title (`Smart Light: Living Room`), its main property and its current status.
   - A colored status dot and device icon: colored while the device is active, grey otherwise.
   - Scheduled devices show their schedule (`Scheduled at 22:30`), provided by the `Schedulable` mixin.

3. **Device Controls:**

   | Device | Property | Status | Control |
   | :--- | :--- | :--- | :--- |
   | **Smart Light** | Brightness (`0%` while off) | `ON` / `OFF` | Switch |
   | **Thermostat** | Target and room temperature | `Heating` / `Cooling` / `Idle` / `OFF` | − / + buttons (limited to 10–30 °C) |
   | **Smart Speaker** | Volume | `Playing` / `Paused` | Play / pause button |

4. **Total Devices Counter:**
   - The bottom text `Total Devices: X` reads the static `SmartDevice.totalDevices` value.
   - The counter increases inside the `SmartDevice` constructor, so devices created with default and named constructors are both counted.
   - Devices are created only once per screen, so rebuilds do not inflate the counter.

---

## Test Cases Checklist

| Requirement / Case | Description | Status |
| :--- | :--- | :---: |
| **Static Device Counter** | Default and named constructors (`SmartLight`, `SmartLight.dimmed`, `Thermostat.eco`, `SmartSpeaker.muted`) each increase `SmartDevice.totalDevices` by one. | Checked |
| **Light Brightness** | A light that is off shows `Brightness: 0%`; turning it on shows its real brightness and status `ON`. | Checked |
| **Thermostat Status** | Status changes from `Heating` to `Idle` to `Cooling` as the target temperature drops below the room temperature, and shows `OFF` when turned off. | Checked |
| **Thermostat Limits** | The target temperature never goes above `Thermostat.maxTemperature`. | Checked |
| **Speaker Disconnect** | Disconnecting a playing speaker marks it disconnected and pauses it (`super.disconnect()`). | Checked |
| **Home Screen Controls** | The home screen lists the devices with `Total Devices: 4`; the switch, + button and play button update brightness, temperature and status. | Checked |

All cases are verified via `flutter test` in `test/models_test.dart` and `test/home_screen_test.dart`.

---

## Known Limitations

- **In-Memory State:** Device states are held in memory during the application session and reset when the application restarts. No database or persistent storage is used.
- **Simulated Devices:** Devices are mock objects; the room temperature is a fixed value and no real hardware is connected.
- **Fixed Brightness & Volume:** Brightness and volume are set when a device is created and are not adjustable from the UI; each device type provides one main control as required.
