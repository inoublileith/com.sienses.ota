// import 'dart:async';
// import 'dart:math';

// import 'package:com_sinses_ota/models/intermdiare_model.dart';
// import 'package:com_sinses_ota/screens/homeScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// import '../widgets/service_tile.dart';
// import '../widgets/characteristic_tile.dart';
// import '../widgets/descriptor_tile.dart';
// import '../utils/snackbar.dart';
// import '../utils/extra.dart';
// import 'package:intl/intl.dart';

// class DeviceScreen extends StatefulWidget {
//   final BluetoothDevice device;

//   const DeviceScreen({Key? key, required this.device}) : super(key: key);

//   @override
//   State<DeviceScreen> createState() => _DeviceScreenState();
// }

// class _DeviceScreenState extends State<DeviceScreen> {
//   int? _rssi;
//   int? _mtuSize;
//   BluetoothConnectionState _connectionState =
//       BluetoothConnectionState.disconnected;
//   List<BluetoothService> _services = [];
//   bool _isDiscoveringServices = false;
//   bool _isConnectingOrDisconnecting = false;

//   late StreamSubscription<BluetoothConnectionState>
//       _connectionStateSubscription;
//   late StreamSubscription<bool> _isConnectingOrDisconnectingSubscription;
//   late StreamSubscription<int> _mtuSubscription;
//   bool showCircle = true;
//   bool showButton = false;
//   bool showSlider = false;
//   bool showHello = false;
//   double _progress = 0.0;
//   late Timer _timer;
//   double _sliderProgress = 0.0;
//   Map<int, double> valueToProgressMap = {
//     1: 1.0,
//     2: 2.0,
//     3: 3.0,
//     4: 4.0,
//     5: 5.0,
//     6: 6.0,
//     7: 7.0,
//     8: 8.0,
//     9: 9.0,
//     10: 10.0,
//     11: 11.0,
//     12: 12.0,
//     13: 13.0,
//     14: 14.0,
//     15: 15.0,
//     16: 16.0,
//     17: 17.0,
//     18: 18.0,
//     19: 19.0,
//     20: 20.0,
//     21: 21.0,
//     22: 22.0,
//     23: 23.0,
//     24: 24.0,
//     25: 25.0,
//     26: 26.0,
//     27: 27.0,
//     28: 28.0,
//     29: 29.0,
//     30: 30.0,
//     31: 31.0,
//     32: 32.0,
//     33: 33.0,
//     34: 34.0,
//     35: 35.0,
//     36: 36.0,
//     37: 37.0,
//     38: 38.0,
//     39: 39.0,
//     40: 40.0,
//     41: 41.0,
//     42: 42.0,
//     43: 43.0,
//     44: 44.0,
//     45: 45.0,
//     46: 46.0,
//     47: 47.0,
//     48: 48.0,
//     49: 49.0,
//     50: 50.0,
//     51: 51.0,
//     52: 52.0,
//     53: 53.0,
//     54: 54.0,
//     55: 55.0,
//     56: 56.0,
//     57: 57.0,
//     58: 58.0,
//     59: 59.0,
//     60: 60.0,
//     61: 61.0,
//     62: 62.0,
//     63: 63.0,
//     64: 64.0,
//     65: 65.0,
//     66: 66.0,
//     67: 67.0,
//     68: 68.0,
//     69: 69.0,
//     70: 70.0,
//     71: 71.0,
//     72: 72.0,
//     73: 73.0,
//     74: 74.0,
//     75: 75.0,
//     76: 76.0,
//     77: 77.0,
//     78: 78.0,
//     79: 79.0,
//     80: 80.0,
//     81: 81.0,
//     82: 82.0,
//     83: 83.0,
//     84: 84.0,
//     85: 85.0,
//     86: 86.0,
//     87: 87.0,
//     88: 88.0,
//     89: 89.0,
//     90: 90.0,
//     91: 91.0,
//     92: 92.0,
//     93: 93.0,
//     94: 94.0,
//     95: 95.0,
//     96: 96.0,
//     97: 97.0,
//     98: 98.0,
//     99: 99.0,
//   };

//   @override
//   void initState() {
//     super.initState();

//     _connectionStateSubscription =
//         widget.device.connectionState.listen((state) async {
//       _connectionState = state;
//       if (state == BluetoothConnectionState.connected) {
//         _services = []; // must rediscover services
//       }
//       if (state == BluetoothConnectionState.connected && _rssi == null) {
//         _rssi = await widget.device.readRssi();
//       }
//       setState(() {});
//     });

//     _mtuSubscription = widget.device.mtu.listen((value) {
//       _mtuSize = value;
//       setState(() {});
//     });

//     _isConnectingOrDisconnectingSubscription =
//         widget.device.isConnectingOrDisconnecting.listen((value) {
//       _isConnectingOrDisconnecting = value;
//       setState(() {});
//     });
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         showCircle = false;
//         showButton = true;
//       });
//     });
//   }

//   void _startProgress() {
//     const totalSeconds = 4; // 4 seconds
//     const updateInterval = 100; // Update every 100 milliseconds
//     const totalUpdates = (totalSeconds * 1000) ~/ updateInterval;
//     final increment = 100.0 / totalUpdates;

//     _timer =
//         Timer.periodic(const Duration(milliseconds: updateInterval), (timer) {
//       if (_progress < 100) {
//         setState(() {
//           _progress += increment;
//         });
//       } else {
//         timer.cancel();
//         showSlider = false;
//         showHello = true;

//         // Show "Hello World" after 2 seconds
//         Future.delayed(const Duration(), () {
//           setState(() {
//             showHello = true;
//           });
//         });
//       }
//     });
//   }

//   void startProgress() {
//     onDiscoverServicesPressed();
//     setState(() {
//       showButton = false;
//       showSlider = true;
//     });

//     // Start the progress when the button is pressed
//     _startProgress();
//   }

//   List<int> _getRandomBytes() {
//     final math = Random();
//     return [
//       math.nextInt(255),
//       math.nextInt(255),
//       math.nextInt(255),
//       math.nextInt(255)
//     ];
//   }

//   @override
//   void dispose() {
//     _connectionStateSubscription.cancel();
//     _mtuSubscription.cancel();
//     _isConnectingOrDisconnectingSubscription.cancel();
//     _timer.cancel();
//     super.dispose();
//   }

//   bool get isConnected {
//     return _connectionState == BluetoothConnectionState.connected;
//   }

//   Future onConnectPressed() async {
//     try {
//       await widget.device.connectAndUpdateStream();
//       Snackbar.show(ABC.c, "Connect: Success", success: true);
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Connect Error:", e),
//           success: false);
//     }
//   }

//   Future onDisconnectPressed() async {
//     try {
//       await widget.device.disconnectAndUpdateStream();
//       Snackbar.show(ABC.c, "Disconnect: Success", success: true);
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Disconnect Error:", e),
//           success: false);
//     }
//   }

//   Future<void> onDiscoverServicesPressed() async {
//     setState(() {
//       _isDiscoveringServices = true;
//     });

//     try {
//       _services = await widget.device.discoverServices();

//       // Iterate through discovered services and their characteristics
//       _services.forEach((s) {
//         s.characteristics.forEach((c) {
//           if (c.characteristicUuid.toString().toUpperCase() ==
//               "68F42438-EE28-11EC-8EA0-0242AC120002") {
//             print("is true ");
//             onWritePressed1(c);
//           }

//           bool read = c.properties.read;
//           bool write = c.properties.write;
//           bool notify = c.properties.notify;
//           bool indicate = c.properties.indicate;
//           if (notify) {
//             print(
//                 'service 1 : UUIDservice :0x${c.serviceUuid.toString().toUpperCase()}, UUIDcharch : 0x${c.uuid.toString().toUpperCase()}, remotId : ${c.remoteId}, to read : ${read}, to write : ${write}, to notify : ${notify}, to indicate : ${indicate}');
//             onSubscribePressed(c);
//           }
//         });
//       });

//       Snackbar.show(ABC.c, "Discover Services: Success", success: true);
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Discover Services Error:", e),
//           success: false);
//     }

//     setState(() {
//       _isDiscoveringServices = false;
//     });
//   }

//   Future onWritePressed1(BluetoothCharacteristic c) async {
//     try {
//       final randomBytes = _getRandomBytes(); // Generate random bytes
//       await c.write(randomBytes,
//           withoutResponse: c.properties.writeWithoutResponse);
//       print('Write: Success');

//       // Check if the written data contains the value 1
//       if (randomBytes.contains(1)) {
//         // If the list contains 1, show a snackbar
//         Snackbar.show(ABC.c, "Received data with value 1", success: true);
//       }

//       if (c.properties.read) {
//         final List<int> readData = await c.read();
//         print("Read Data: $readData"); // Print the read data to the terminal
//       }
//     } catch (e) {
//       print("Write Error: $e");
//       Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
//     }
//   }

//   Future onSubscribePressed(BluetoothCharacteristic characteristic) async {
//     print('Subscribing to characteristic: ${characteristic.uuid}');
//     await characteristic.setNotifyValue(true).then((_) {
//       print('Subscribed to characteristic: ${characteristic.uuid}');
//     }).catchError((error) {
//       print('Error subscribing to characteristic: ${characteristic.uuid}');
//       print('Error details: $error');
//     });

//     // Listen for characteristic value changes
//     // ignore: deprecated_member_use
//     characteristic.value.listen((value) {
//       // print('Characteristic value changed: ${characteristic.uuid}');
//       // print('New value: $value');

//       // Update the slider progress based on the received values using the map
//       if (valueToProgressMap.containsKey(value)) {
//         _updateSliderProgress(valueToProgressMap[value]!);

//         // Perform any additional actions you need for the specific value case here.
//         if (value == 99) {
//           // Handle the 99 case here.
//         }
//       } else {
//         // Handle other cases if needed
//       }
//     });
//   }

//   void _updateSliderProgress(double progress) {
//     setState(() {
//       _sliderProgress = progress;
//     });
//   }

//   Future onRequestMtuPressed() async {
//     try {
//       await widget.device.requestMtu(223);
//       Snackbar.show(ABC.c, "Request Mtu: Success", success: true);
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Change Mtu Error:", e),
//           success: false);
//     }
//   }

//   List<Widget> _buildServiceTiles(BuildContext context, BluetoothDevice d) {
//     return _services
//         .map(
//           (s) => ServiceTile(
//             service: s,
//             characteristicTiles: s.characteristics
//                 .map((c) => _buildCharacteristicTile(c))
//                 .toList(),
//           ),
//         )
//         .toList();
//   }

//   CharacteristicTile _buildCharacteristicTile(BluetoothCharacteristic c) {
//     return CharacteristicTile(
//       characteristic: c,
//       descriptorTiles:
//           c.descriptors.map((d) => DescriptorTile(descriptor: d)).toList(),
//     );
//   }

//   Widget buildSpinner(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.all(14.0),
//       child: AspectRatio(
//         aspectRatio: 1.0,
//         child: CircularProgressIndicator(
//           backgroundColor: Colors.black12,
//           color: Colors.black26,
//         ),
//       ),
//     );
//   }

//   Widget buildConnectOrDisconnectButton(BuildContext context) {
//     return TextButton(
//         onPressed: isConnected ? onDisconnectPressed : onConnectPressed,
//         child: Text(
//           isConnected ? "DISCONNECT" : "CONNECT",
//           style: Theme.of(context)
//               .primaryTextTheme
//               .labelLarge
//               ?.copyWith(color: Colors.white),
//         ));
//   }

//   Widget buildRemoteId(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text('${widget.device.remoteId}'),
//     );
//   }

//   Widget buildRssiTile(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         isConnected
//             ? const Icon(Icons.bluetooth_connected)
//             : const Icon(Icons.bluetooth_disabled),
//         Text(((isConnected && _rssi != null) ? '${_rssi!} dBm' : ''),
//             style: Theme.of(context).textTheme.bodySmall)
//       ],
//     );
//   }

//   Widget buildGetServices(BuildContext context) {
//     return IndexedStack(
//       index: (_isDiscoveringServices) ? 1 : 0,
//       children: <Widget>[
//         TextButton(
//           child: const Text("Get Services"),
//           onPressed: onDiscoverServicesPressed,
//         ),
//         const IconButton(
//           icon: SizedBox(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation(Colors.grey),
//             ),
//             width: 18.0,
//             height: 18.0,
//           ),
//           onPressed: null,
//         )
//       ],
//     );
//   }

//   Widget buildMtuTile(BuildContext context) {
//     return ListTile(
//         title: const Text('MTU Size'),
//         subtitle: Text('$_mtuSize bytes'),
//         trailing: IconButton(
//           icon: const Icon(Icons.edit),
//           onPressed: onRequestMtuPressed,
//         ));
//   }

//   Widget buildConnectScreen(BuildContext context) {
//     if (_isConnectingOrDisconnecting) {
//       return buildSpinner(context);
//     } else {
//       return buildConnectOrDisconnectButton(context);
//     }
//   }

//   Widget buildConnectButton(BuildContext context) {
//     if (_isConnectingOrDisconnecting) {
//       return buildSpinner(context);
//     } else {
//       return buildConnectOrDisconnectButton(context);
//     }
//   }

//   Widget ScreenConnection(BuildContext context) {
//     if (_connectionState == BluetoothConnectionState.connected) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (showCircle) ...[
//             // Display the circle for 2 seconds
//             const CircularProgressIndicator(),
//           ],
//           if (showButton) ...[
//             // Display the button after the circle
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey,
//                           blurRadius: 5.0,
//                           spreadRadius: 1.0,
//                         ),
//                       ],
//                     ),
//                     child: const Text(
//                       'OTA',
//                       style: TextStyle(
//                         fontSize: 36,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 100),
//                   ElevatedButton(
//                     onPressed: startProgress,
//                     child: const Text('Start Progress'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//           if (showSlider) ...[
//             // Display the slider progress for 4 seconds
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Progress: ${_sliderProgress.toStringAsFixed(0)}%'),
//                   Slider(
//                     value: _sliderProgress,
//                     onChanged: (value) {},
//                     min: 0,
//                     max: 100,
//                     divisions: 100,
//                   )
//                 ],
//               ),
//             ),
//           ],
//           if (showHello) ...[
//             Center(
//               child: FutureBuilder<List<IntermModel>>(
//                 future: dbService.fetchFirmsByDevice(
//                     mac: "${widget.device.remoteId}"),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<List<IntermModel>> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator(); // Display a loading indicator while fetching data.
//                   } else if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   }

//                   final intermModels = snapshot.data;

//                   if (intermModels == null || intermModels.isEmpty) {
//                     return const Text('No data available.');
//                   }

//                   final intermModel = intermModels[0]; // Access the first item.

//                   String date;
//                   return Container(
//                     alignment: Alignment.center, // Center and maximize contents
//                     child: Stack(
//                       children: [
//                         Container(
//                           decoration: const BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [Color(0xfffe5788), Color(0xfff56d5d)],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width *
//                                 0.8, // 80% of screen width
//                             height: MediaQuery.of(context).size.height *
//                                 0.7, // 70% of screen height
//                             child: Card(
//                               elevation: 10,
//                               child: Stack(
//                                 children: [
//                                   // Pattern background
//                                   Opacity(
//                                     opacity: 0.1,
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(4),
//                                         image: const DecorationImage(
//                                           image: AssetImage(
//                                               "images/pattern-2.png"),
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   // top image
//                                   Container(
//                                     height: MediaQuery.of(context).size.height *
//                                         0.35, // 35% of card height
//                                     decoration: const BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(4),
//                                         topRight: Radius.circular(4),
//                                       ),
//                                       image: DecorationImage(
//                                         image: NetworkImage(
//                                           "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxHEli1Vu9_4llbjk3t_IagkvwwZqcZF7gOA&usqp=CAU",
//                                         ),
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                   // text
//                                   Container(
//                                     margin: EdgeInsets.fromLTRB(
//                                       20,
//                                       50 +
//                                           MediaQuery.of(context).size.height *
//                                               0.35,
//                                       20,
//                                       20,
//                                     ),
//                                     child: Center(
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               const Text(
//                                                 "Version :",
//                                                 maxLines: 2,
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                   color: Colors.indigo,
//                                                   fontSize: 25,
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Text(
//                                                 " ${intermModel.version}",
//                                                 maxLines: 2,
//                                                 textAlign: TextAlign.center,
//                                                 style: const TextStyle(
//                                                   color: Color.fromARGB(
//                                                       255, 122, 54, 54),
//                                                   fontSize: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Container(
//                                             margin: const EdgeInsets.fromLTRB(
//                                                 0, 20, 0, 15),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 const Text(
//                                                   "Created At ",
//                                                   style: TextStyle(
//                                                     color: Colors.indigo,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "${DateFormat("EEEE/MM/dd HH:mm").format(intermModel.createdAt)}",
//                                                   style: const TextStyle(
//                                                     color: Color.fromARGB(
//                                                         255, 122, 54, 54),
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const Row(
//                                             children: [
//                                               Spacer(
//                                                 flex: 10,
//                                               ),
//                                               Icon(
//                                                 Icons.thumb_up,
//                                                 size: 18,
//                                                 color: Colors.grey,
//                                               ),
//                                               Spacer(
//                                                 flex: 1,
//                                               ),
//                                               Text(
//                                                 "99",
//                                                 style: TextStyle(
//                                                   color: Colors.grey,
//                                                 ),
//                                               ),
//                                               Spacer(
//                                                 flex: 5,
//                                               ),
//                                               Icon(
//                                                 Icons.comment,
//                                                 size: 18,
//                                                 color: Colors.grey,
//                                               ),
//                                               Spacer(
//                                                 flex: 1,
//                                               ),
//                                               Text(
//                                                 "888",
//                                                 style: TextStyle(
//                                                   color: Colors.grey,
//                                                 ),
//                                               ),
//                                               Spacer(
//                                                 flex: 10,
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ],
//       );
//     } else {
//       return Container(
//         alignment: Alignment.center,
//         child: Text(
//           "You should connect to see the firmWare Version",
//           style: TextStyle(color: Colors.indigo, fontSize: 12),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldMessenger(
//       key: Snackbar.snackBarKeyC,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.device.platformName),
//           actions: [buildConnectButton(context)],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               buildRemoteId(context),
//               ListTile(
//                 leading: buildRssiTile(context),
//                 title: Text(
//                     'Device is ${_connectionState.toString().split('.')[1]}.'),
//                 // trailing: buildGetServices(context),
//               ),
//               // buildMtuTile(context),
//               // ..._buildServiceTiles(context, widget.device),
//               const SizedBox(
//                 height: 60,
//               ),

//               ScreenConnection(context)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
