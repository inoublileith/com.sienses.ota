import 'dart:async';
import 'package:intl/intl.dart';
import 'package:com_sinses_ota/models/intermdiare_model.dart';
import 'package:com_sinses_ota/screens/homeScreen.dart';
import 'package:com_sinses_ota/screens/user/scan_screen.dart';
import 'package:com_sinses_ota/screens/user/widgets/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap}) : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription = widget.result.device.connectionState.listen((state) {
      _connectionState = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    return data.entries
        .map((entry) => '${entry.key.toRadixString(16)}: ${getNiceHexArray(entry.value)}')
        .join(', ')
        .toUpperCase();
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    return data.entries.map((v) => '${v.key}: ${getNiceHexArray(v.value)}').join(', ').toUpperCase();
  }

  String getNiceServiceUuids(List<String> serviceUuids) {
    return serviceUuids.isEmpty ? 'N/A' : serviceUuids.join(', ').toUpperCase();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Widget _buildTitle(BuildContext context) {
    if (widget.result.device.platformName.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.result.device.platformName,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.result.device.remoteId.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );
    } else {
      return Text(widget.result.device.remoteId.toString());
    }
  }

  Widget _buildConnectButton(BuildContext context) {
   
    String LocalName= widget.result.device.remoteId.toString();
    return ElevatedButton(
      child: isConnected ? const Text('OPEN') : const Text('Connect'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: (){
         Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MyScreen(name: LocalName, ),
          ));
      }
    );
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var adv = widget.result.advertisementData;
    return ExpansionTile(
      title: _buildTitle(context),
      leading: Text(widget.result.rssi.toString()),
      trailing: _buildConnectButton(context),
      children: <Widget>[
        _buildAdvRow(context, 'Complete Local Name', adv.localName),
        _buildAdvRow(context, 'Tx Power Level', '${adv.txPowerLevel ?? 'N/A'}'),
        _buildAdvRow(context, 'Manufacturer Data', getNiceManufacturerData(adv.manufacturerData)),
        _buildAdvRow(context, 'Service UUIDs', getNiceServiceUuids(adv.serviceUuids)),
        _buildAdvRow(context, 'Service Data', getNiceServiceData(adv.serviceData)),
      ],
    );
  }
}


// ignore: must_be_immutable







class MyScreen extends StatefulWidget {
   String name;

  MyScreen({required this.name});
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool showCircle = true;
  bool showButton = false;
  bool showSlider = false;
  bool showHello = false;
  double _progress = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Show the circle for 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showCircle = false;
        showButton = true;
      });
    });
  }

  void _startProgress() {
    const totalSeconds = 4; // 4 seconds
    const updateInterval = 100; // Update every 100 milliseconds
    const totalUpdates = (totalSeconds * 1000) ~/ updateInterval;
    final increment = 100.0 / totalUpdates;

    _timer =
        Timer.periodic(const Duration(milliseconds: updateInterval), (timer) {
      if (_progress < 100) {
        setState(() {
          _progress += increment;
        });
      } else {
        timer.cancel();
        showSlider = false;
        showHello = true;

        // Show "Hello World" after 2 seconds
        Future.delayed(Duration(), () {
          setState(() {
            showHello = true;
          });
        });
      }
    });
  }

  void startProgress() {
    setState(() {
      showButton = false;
      showSlider = true;
    });

    // Start the progress when the button is pressed
    _startProgress();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTA Progrees'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showCircle) ...[
              // Display the circle for 2 seconds
              CircularProgressIndicator(),
            ],
            if (showButton) ...[
              // Display the button after the circle
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: const Text(
                        'OTA',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    ElevatedButton(
                      onPressed: startProgress,
                      child: const Text('Start Progress'),
                    ),
                  ],
                ),
              ),
             
            ],
            if (showSlider) ...[
              // Display the slider progress for 4 seconds
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Progress: ${_progress.toStringAsFixed(1)}%'),
                    Slider(
                      value: _progress,
                      onChanged: (value) {},
                      min: 0,
                      max: 100,
                      divisions: 100,
                    ),
                  ],
                ),
              ),
            ],
            if (showHello) ...[
              
             Center(
                child: FutureBuilder<List<IntermModel>>(
                  future: dbService.fetchFirmsByDevice(mac: widget.name),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<IntermModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Display a loading indicator while fetching data.
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final intermModels = snapshot.data;

                    if (intermModels == null || intermModels.isEmpty) {
                      return Text('No data available.');
                    }

                    final intermModel =
                        intermModels[0]; // Access the first item.

                    String date;
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Version: ${intermModel.version}'),
                          Text('Created At: ${intermModel.createdAt}'),
                          // Text(
                          //     'Created At: ${DateFormat('EE \n dd').format(intermModel.createdAt)}'),
                  
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
