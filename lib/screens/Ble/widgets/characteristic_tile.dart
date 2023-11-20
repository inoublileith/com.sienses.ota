import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import "../utils/snackbar.dart";

import "descriptor_tile.dart";

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;

  const CharacteristicTile({Key? key, required this.characteristic, required this.descriptorTiles}) : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  List<int> _value = [];

  late StreamSubscription<List<int>> _lastValueSubscription;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription = widget.characteristic.lastValueStream.listen((value) {
      _value = value;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BluetoothCharacteristic get c => widget.characteristic;

  List<int> _getRandomBytes() {
    final math = Random();
    return [math.nextInt(255), math.nextInt(255), math.nextInt(255), math.nextInt(255)];
  }

  Future onReadPressed() async {
    try {
      await c.read();
      Snackbar.show(ABC.c, "Read: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Read Error:", e), success: false);
    }
  }

  Future onWritePressed() async {
  try {
      await c.write(_getRandomBytes(), withoutResponse: c.properties.writeWithoutResponse);
      Snackbar.show(ABC.c, "Write: Success", success: true);
      if (c.properties.read) {
        final List<int> readData = await c.read();
        print("Read Data: $readData"); // Print the read data to the terminal
      }
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }

   
  }
  Future onWritePressed1() async {
    try {
      final randomBytes = _getRandomBytes(); // Generate random bytes
      await c.write(randomBytes, withoutResponse: c.properties.writeWithoutResponse);
      print('Write: Success');

      // Check if the written data contains the value 1
      if (randomBytes.contains(1)) {
        // If the list contains 1, show a snackbar
        Snackbar.show(ABC.c, "Received data with value 1", success: true);
      }

      if (c.properties.read) {
        final List<int> readData = await c.read();
        print("Read Data: $readData"); // Print the read data to the terminal
      }
    } catch (e) {
      print("Write Error: $e");
      Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    }
  }

Future onSubscribePressed(BluetoothCharacteristic characteristic) async {
    print('Subscribing to characteristic: ${characteristic.uuid}');
    await characteristic.setNotifyValue(true).then((_) {
      print('Subscribed to characteristic: ${characteristic.uuid}');
    }).catchError((error) {
      print('Error subscribing to characteristic: ${characteristic.uuid}');
      print('Error details: $error');
    });

    // Listen for characteristic value changes
    // ignore: deprecated_member_use
    characteristic.value.listen((value) {
      print('Characteristic value changed: ${characteristic.uuid}');
      print('New value: $value');
       _value = value;
      setState(() {
        if (_value.contains(1)) {
          // If the list contains 1, show a snackbar
          Snackbar.show(ABC.c, "Http Event On Connected", success: true);
        }
        else if ( _value.contains(2)){
          Snackbar.show(ABC.c , "Http Event Header Sent",success : true );
        }
        else if(_value.contains(99))
        {
           onWritePressed1();
          setState(() {});
        }
        else {
           Snackbar.show(ABC.c, "Message", success: true);
        }
      });
      // setState(() {});
    });
  }
  // Future onSubscribePressed() async {
  //   try {
  //     String op = c.isNotifying == false ? "Subscribe" : "Unubscribe";
  //     await c.setNotifyValue(c.isNotifying == false);
  //     Snackbar.show(ABC.c, "$op : Success", success: true);
  //     if (c.properties.read) {
  //       await c.read();
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     Snackbar.show(ABC.c, prettyException("Subscribe Error:", e), success: false);
  //   }
  // }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.characteristic.uuid.toString().toUpperCase()}';
    return Text(uuid, style: TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    return Text(data, style: TextStyle(fontSize: 20, color: Colors.green));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
        child: Text("Read"),
        onPressed: () async {
          await onReadPressed();
          setState(() {});
        });
  }

  Widget buildWriteButton(BuildContext context) {
    bool withoutResp = widget.characteristic.properties.writeWithoutResponse;
    return TextButton(
        child: Text(withoutResp ? "WriteNoResp" : "Write"),
        onPressed: () async {
          await onWritePressed1();
          setState(() {});
        });
  }

  Widget buildSubscribeButton(BuildContext context) {
    bool isNotifying = widget.characteristic.isNotifying;
    return TextButton(
        child: Text(isNotifying ? "Unsubscribe" : "Subscribe"),
        onPressed: () async {
          await onSubscribePressed(widget.characteristic);
          setState(() {});
        });
  }

  Widget buildButtonRow(BuildContext context) {
    bool read = widget.characteristic.properties.read;
    bool write = widget.characteristic.properties.write;
    bool notify = widget.characteristic.properties.notify;
    bool indicate = widget.characteristic.properties.indicate;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (read) buildReadButton(context),
        if (write) buildWriteButton(context),
        if (notify || indicate) buildSubscribeButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Characteristic'),
            buildUuid(context),
            buildValue(context),
          ],
        ),
        subtitle: buildButtonRow(context),
        contentPadding: const EdgeInsets.all(0.0),
      ),
      children: widget.descriptorTiles,
    );
  }
}
