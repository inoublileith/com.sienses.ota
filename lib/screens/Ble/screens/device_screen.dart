// ignore_for_file: constant_identifier_names, deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:OTA/models/intermdiare_model.dart';
import 'package:OTA/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../widgets/service_tile.dart';
import '../widgets/characteristic_tile.dart';
import '../widgets/descriptor_tile.dart';
import '../utils/snackbar.dart';
import '../utils/extra.dart';
import 'package:intl/intl.dart';

class DeviceScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  int? _rssi;
  int? _mtuSize;
  late List<int> version = [];
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  List<BluetoothService> _services = [];

  bool _isDiscoveringServices = false;
  bool _isConnectingOrDisconnecting = false;
  late int first = 1;
  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;
  late StreamSubscription<bool> _isConnectingOrDisconnectingSubscription;
  late StreamSubscription<int> _mtuSubscription;
  bool showCircle = true;
  bool showButton = false;
  bool showSlider = false;
  bool showHello = false;
  double _progress = 0.0;
  late Timer _timer;
  bool clear = false;
  List<int> readData = [];
  // List<int> version = [];
  @override
  void initState() {
    super.initState();

    _connectionStateSubscription =
        widget.device.connectionState.listen((state) async {
      _connectionState = state;
      if (state == BluetoothConnectionState.connected) {
        _services = [];
        discoverVersion();
        //  onSubscribeDiscover(); // must rediscover services
      }
      if (state == BluetoothConnectionState.connected && _rssi == null) {
        _rssi = await widget.device.readRssi();
      }
      setState(() {});
    });

    _mtuSubscription = widget.device.mtu.listen((value) {
      _mtuSize = value;
      setState(() {});
    });

    _isConnectingOrDisconnectingSubscription =
        widget.device.isConnectingOrDisconnecting.listen((value) {
      _isConnectingOrDisconnecting = value;
      setState(() {});
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showCircle = false;
        showButton = true;
      });
    });
    //    setState(() {
    //      first = 12;
    //    });
    //  print(first);
  }

  void _startProgress() {
    const totalSeconds = 5;
    const updateInterval = 100;
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
        Future.delayed(const Duration(), () {
          setState(() {
            showSlider = true;
          });
        });
      }
    });
  }

  // void startProgress() {
  //   setState(() {
  //     showButton = false;
  //     showCircle = true;
  //     showSlider = false;
  //   });
  //   onSubscribeDiscover().then((value) => onWriteDiscover());
  //   // _startProgress();
  // }

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
    _isConnectingOrDisconnectingSubscription.cancel();
    _timer.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Future onConnectPressed() async {
    try {
      await widget.device.connectAndUpdateStream();
      Snackbar.show(ABC.c, "BLE Connect Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    }
  }

  Future onDisconnectPressed() async {
    try {
      await widget.device.disconnectAndUpdateStream();
      Snackbar.show(ABC.c, " BLE Disconnect Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Disconnect Error:", e),
          success: false);
    }
  }

  bool _isListening = true;

  Future<void> onSubscribeDiscover() async {
    setState(() {
      _isDiscoveringServices = true;
    });

    try {
      Snackbar.show(ABC.c, "Begin notification", success: true);
      _services = await widget.device.discoverServices();
      _services.forEach((s) {
        s.characteristics.forEach((c) async {
          print('Subscribing to characteristic: ${c.uuid}');
          await c.setNotifyValue(true).then((_) {
            print('Subscribed to characteristic: ${c.uuid}');
          }).catchError((error) {
            print('Error subscribing to characteristic: ${c.uuid}');
            print('Error details: $error');
          });

          StreamSubscription<List<int>>? _subscription;
          _subscription = c.value.listen((value) {
            print('Characteristic value changed: ${c.uuid}');
            int num = value.first;
            print('New value: $num');

            switch (num) {
              case CharacteristicValues.HTTP_EVENT_ON_CONNECTED:
                Snackbar.show(ABC.c, "HTTP Event On Connected", success: true);
                break;
              case CharacteristicValues.HTTP_EVENT_HEADER_SENT:
                Snackbar.show(ABC.c, "HTTP Event Header Sent", success: true);
                break;
              case CharacteristicValues.HTTP_EVENT_ON_HEADER:
                Snackbar.show(ABC.c, "HTTP Event On Header", success: true);
                break;
              case CharacteristicValues.HTTP_EVENT_ON_FINISH:
                Snackbar.show(ABC.c, "HTTP Event On Finish", success: true);
                break;
              case CharacteristicValues.HTTP_EVENT_DISCONNECTED:
                Snackbar.show(ABC.c, "HTTP Event Disconnected", success: true);
                break;
              case CharacteristicValues.HTTP_EVENT_REDIRECT:
                Snackbar.show(ABC.c, "HTTP Event Redirect", success: true);
                break;
              case CharacteristicValues.HTTPS_OTA_FAIL:
                Snackbar.show(ABC.c, "HTTPS Ota Fail", success: true);
                setState(() {
                  showCircle = false;
                  showButton = true;
                });
                break;
              case CharacteristicValues.HTTPS_OTA_SUCCESS:
                Snackbar.show(ABC.c, "HTTPS OTA SUCCESS", success: true);
                setState(() {
                  showCircle = false;
                  showSlider = true;
                });
                break;
              case CharacteristicValues.HTTP_EVENT_ON_DATA:
                Snackbar.show(ABC.c, "HTTPS EVENT ON DATA", success: true);
                break;
              case CharacteristicValues.HTTP_EVENT_ERROR:
                Snackbar.show(ABC.c, "HTTPS EVENT ERROR", success: true);
                break;
              case CharacteristicValues.HTTP_FW_UP_TO_DATE:
                Snackbar.show(ABC.c, " HTTP No new version", success: true);
            }
          });
        });
      });

      Snackbar.show(ABC.c, "BLE Discover Services Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Discover Services Error:", e),
          success: false);
    }

    setState(() {
      _isDiscoveringServices = false;
    });
  }

  Future<void> discoverVersion() async {
    setState(() {
      _isDiscoveringServices = true;
    });

    try {
      _services = await widget.device.discoverServices();
      for (BluetoothService service in _services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          print('Subscribing to characteristic: ${characteristic.uuid}');
          await characteristic.setNotifyValue(true).then((_) {
            print('Subscribed to characteristic: ${characteristic.uuid}');
          }).catchError((error) {
            print(
                'Error subscribing to characteristic: ${characteristic.uuid}');
            print('Error details: $error');
          });
          if (characteristic.uuid.toString() ==
              "00002a26-0000-1000-8000-00805f9b34fb") {
            print('Reading value for characteristic: ${characteristic.uuid}');
            try {
              List<int> readValue = await characteristic.read();
              print('Characteristic value: $readValue');
              setState(() {
                version = readValue;
              });
            } catch (e) {
              print('Error reading characteristic: $e');
            }
          }
        }
      }
      Snackbar.show(ABC.c, "BLE Discover Services Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Discover Services Error:", e),
          success: false);
    }

    setState(() {
      _isDiscoveringServices = false;
    });
  }

  Future<void> writeOtaRequest() async {
    try {
      _services = await widget.device.discoverServices();
      for (BluetoothService service in _services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid.toString().toUpperCase() ==
              "68F42438-EE28-11EC-8EA0-0242AC120002") {
            if (characteristic.properties.write) {
              await characteristic.write([2]).then((value) {
                print('Write operation successful');
                setState(() {
                  showButton = false;
                  showCircle = true;
                });
              }).catchError((error) {
                print('Error writing command to the device: $error');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content:
                          Text('Error writing command to the device: $error'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              });
            }
          }
        }
      }
    } catch (error) {
      print('Error discovering services: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error discovering services: $error'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> writeRestartRequest() async {
    try {
      _services = await widget.device.discoverServices();
      _services.forEach((service) {
        service.characteristics.forEach((characteristic) async {
          if (characteristic.properties.write) {
            await characteristic.write([1]);
          }
        });
      });

      Future.delayed(Duration(seconds: 3), () {
        onDisconnectPressed();
      }).then((value) {
        setState(() {
          showSlider = false;
          showButton = true;
        });
      }).then((value) {
        Future.delayed(Duration(seconds: 3), () {
          onConnectPressed();
        });
      });
    } catch (error) {
      print('Error writing command to the device: $error');
    }
  }

  Future<void> writeStatusRequest() async {
    try {
      _services = await widget.device.discoverServices();
      _services.forEach((service) {
        service.characteristics.forEach((characteristic) async {
          if (characteristic.properties.write) {
            await characteristic.write([3], withoutResponse: true);
            List<int> readData = await characteristic.read();
            Snackbar.show(ABC.c, "$readData", success: true);
            print('Read Data: $readData');
          }
        });
      });
    } catch (error) {
      print('Error writing command to the device: $error');
    }
  }

  Future onRequestMtuPressed() async {
    try {
      await widget.device.requestMtu(223);
      Snackbar.show(ABC.c, "Request Mtu: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Change Mtu Error:", e),
          success: false);
    }
  }

  List<Widget> _buildServiceTiles(BuildContext context, BluetoothDevice d) {
    return _services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map((c) => _buildCharacteristicTile(c))
                .toList(),
          ),
        )
        .toList();
  }

  CharacteristicTile _buildCharacteristicTile(BluetoothCharacteristic c) {
    return CharacteristicTile(
      characteristic: c,
      descriptorTiles:
          c.descriptors.map((d) => DescriptorTile(descriptor: d)).toList(),
    );
  }

  Widget buildSpinner(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(14.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CircularProgressIndicator(
          backgroundColor: Colors.black12,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget buildConnectOrDisconnectButton(BuildContext context) {
    return TextButton(
        onPressed: isConnected ? onDisconnectPressed : onConnectPressed,
        child: Text(
          isConnected ? "DISCONNECT" : "CONNECT",
          style: Theme.of(context)
              .primaryTextTheme
              .labelLarge
              ?.copyWith(color: Colors.white),
        ));
  }

  Widget buildRemoteId(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('${widget.device.remoteId}'),
    );
  }

  Widget buildRssiTile(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isConnected
            ? const Icon(Icons.bluetooth_connected)
            : const Icon(Icons.bluetooth_disabled),
        Text(((isConnected && _rssi != null) ? '${_rssi!} dBm' : ''),
            style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }

  Widget buildGetServices(BuildContext context) {
    return IndexedStack(
      index: (_isDiscoveringServices) ? 1 : 0,
      children: <Widget>[
        TextButton(child: const Text("Get Services"), onPressed: () {}),
        const IconButton(
          icon: SizedBox(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.grey),
            ),
            width: 18.0,
            height: 18.0,
          ),
          onPressed: null,
        )
      ],
    );
  }

  Widget buildMtuTile(BuildContext context) {
    return ListTile(
        title: const Text('MTU Size'),
        subtitle: Text('$_mtuSize bytes'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onRequestMtuPressed,
        ));
  }

  Widget buildConnectScreen(BuildContext context) {
    if (_isConnectingOrDisconnecting) {
      return buildSpinner(context);
    } else {
      return buildConnectOrDisconnectButton(context);
    }
  }

  Widget buildConnectButton(BuildContext context) {
    if (_isConnectingOrDisconnecting) {
      return buildSpinner(context);
    } else {
      return buildConnectOrDisconnectButton(context);
    }
  }

  Widget ScreenConnection(BuildContext context) {
    if (_connectionState == BluetoothConnectionState.connected) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showCircle) ...[
         
            const CircularProgressIndicator(),
          ],
          if (showButton) ...[
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
                  const SizedBox(height: 10),
                  Text("Version: ${String.fromCharCodes(version)}"),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () {
                      writeOtaRequest().then((value) => onSubscribeDiscover());
                    },
                    child: const Text('OTA Begin'),
                  ),
                  const SizedBox(height:10),
                  ElevatedButton(onPressed:(){
                    writeStatusRequest();
                  }, child: const Text('OTA Status '))
                ],
              ),
            ),
          ],
          if (showSlider) ...[
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
                  const SizedBox(height: 10),
                  Text("Version: ${String.fromCharCodes(version)}"),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () {
                      writeRestartRequest();
                    },
                    child: const Text('Restart'),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed:(){
                    writeStatusRequest();
                  }, child: const Text("OTA Status "))
                ],
              ),
            ),
          ],
          if (showHello) ...[
            Center(
              child: FutureBuilder<List<IntermModel>>(
                future: dbService.fetchFirmsByDevice(
                    mac: "${widget.device.remoteId}"),
                builder: (BuildContext context,
                    AsyncSnapshot<List<IntermModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Display a loading indicator while fetching data.
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final intermModels = snapshot.data;

                  if (intermModels == null || intermModels.isEmpty) {
                    return const Text('No data available.');
                  }

                  final intermModel = intermModels[0]; // Access the first item.

                  String date;
                  return Container(
                    alignment: Alignment.center, // Center and maximize contents
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xfffe5788), Color(0xfff56d5d)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.8, // 80% of screen width
                            height: MediaQuery.of(context).size.height *
                                0.7, // 70% of screen height
                            child: Card(
                              elevation: 10,
                              child: Stack(
                                children: [
                                  // Pattern background
                                  // Opacity(
                                  //   opacity: 0.1,
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(4),
                                  //       image: const DecorationImage(
                                  //         image: AssetImage(
                                  //             ""),
                                  //         fit: BoxFit.cover,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // top image
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.35, // 35% of card height
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxHEli1Vu9_4llbjk3t_IagkvwwZqcZF7gOA&usqp=CAU",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // text
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      20,
                                      50 +
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      20,
                                      20,
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "Version :",
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.indigo,
                                                  fontSize: 25,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "$readData",
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 122, 54, 54),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 20, 0, 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Created At ",
                                                  style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  "${DateFormat("EEEE/MM/dd HH:mm").format(intermModel.createdAt)}",
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 122, 54, 54),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Row(
                                            children: [
                                              Spacer(
                                                flex: 10,
                                              ),
                                              Icon(
                                                Icons.thumb_up,
                                                size: 18,
                                                color: Colors.grey,
                                              ),
                                              Spacer(
                                                flex: 1,
                                              ),
                                              Text(
                                                "99",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Spacer(
                                                flex: 5,
                                              ),
                                              Icon(
                                                Icons.comment,
                                                size: 18,
                                                color: Colors.grey,
                                              ),
                                              Spacer(
                                                flex: 1,
                                              ),
                                              Text(
                                                "888",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Spacer(
                                                flex: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text(
          "You should connect to see the firmWare Version",
          style: TextStyle(color: Colors.indigo, fontSize: 12),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyC,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.device.platformName),
          actions: [buildConnectButton(context)],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildRemoteId(context),
              ListTile(
                leading: buildRssiTile(context),
                title: Text(
                    'Device is ${_connectionState.toString().split('.')[1]}.'),
                trailing: buildGetServices(context),
              ),
              // buildMtuTile(context),
              // ..._buildServiceTiles(context, widget.device),
              const SizedBox(
                height: 60,
              ),

              ScreenConnection(context)
            ],
          ),
        ),
      ),
    );
  }
}

// enum CharacteristicValue {
//   HTTP_EVENT_ON_CONNECTED = 99,
//   HTTP_EVENT_HEADER_SENT,
//   HTTP_EVENT_ON_HEADER,
//   HTTP_EVENT_ON_FINISH,
//   HTTP_EVENT_DISCONNECTED,

//   HTTPS_OTA_FAIL,
//   HTTPS_OTA_SUCCESS,
//   HTTP_EVENT_ON_DATA,
//   HTTP_EVENT_ERROR
// }
class CharacteristicValues {
  static const int HTTP_EVENT_ON_CONNECTED = 99;
  static const int HTTP_EVENT_HEADER_SENT = 98;
  static const int HTTP_EVENT_ON_HEADER = 97;
  static const int HTTP_EVENT_ON_FINISH = 96;
  static const int HTTP_EVENT_DISCONNECTED = 95;
  static const int HTTP_EVENT_REDIRECT = 94;
  static const int HTTPS_OTA_FAIL = 93;
  static const int HTTPS_OTA_SUCCESS = 92;
  static const int HTTP_EVENT_ON_DATA = 91;
  static const int HTTP_EVENT_ERROR = 90;
  static const int HTTP_FW_UP_TO_DATE = 89;
}
