

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectedDeviceTile extends StatefulWidget {
  final BluetoothDevice device;
  final VoidCallback onOpen;
  final VoidCallback onConnect;

  const ConnectedDeviceTile({
    required this.device,
    required this.onOpen,
    required this.onConnect,
    Key? key,
  }) : super(key: key);

  @override
  State<ConnectedDeviceTile> createState() => _ConnectedDeviceTileState();
}
class _ConnectedDeviceTileState extends State<ConnectedDeviceTile> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription =
        widget.device.connectionState.listen((state) {
      _connectionState = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Future<void> navigateToLoadingScreen() async {
    if (isConnected) {
      // Navigate to the loading screen
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoadingScreen(),
      ));

      // Delay for 2 seconds
      await Future.delayed(Duration(seconds: 2));

      // Navigate to the device ID screen
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            DeviceIDScreen(deviceID: widget.device.remoteId.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.device.platformName),
      subtitle: Text(widget.device.remoteId.toString()),
      trailing: ElevatedButton(
        child:  const Text('go'),
        onPressed: navigateToLoadingScreen,
      ),
    );
  }
}
class DeviceIDScreen extends StatelessWidget {
  final String deviceID;

  DeviceIDScreen({required this.deviceID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device ID Screen'),
      ),
      body: Center(
        child: Text('Device ID: $deviceID'),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loading Screen'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
