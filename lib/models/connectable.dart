/// Contract for devices that can join and leave the home network.
abstract interface class Connectable {
  bool get isConnected;

  void connect();

  void disconnect();
}
