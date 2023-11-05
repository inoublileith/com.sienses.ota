import 'package:com_sinses_ota/models/device_model.dart';
import 'package:com_sinses_ota/models/users_model.dart';
import 'package:com_sinses_ota/screens/admin/device/Edit_Admin_Device.dart';
import 'package:com_sinses_ota/screens/homeScreen.dart';
import 'package:com_sinses_ota/screens/super_admin/user/Edit_User.dart';
import 'package:com_sinses_ota/screens/super_admin/device/edit_device.dart';
import 'package:com_sinses_ota/services/DbService.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

const Widget divider = SizedBox(height: 10);

// If screen content width is greater or equal to this value, the light and dark
// color schemes will be displayed in a column. Otherwise, they will
// be displayed in a row.
const double narrowScreenWidthThreshold = 100;

class AdminDeviceScreen extends StatefulWidget {
  const AdminDeviceScreen({Key? key}) : super(key: key);

  @override
  _AdminDeviceScreenState createState() => _AdminDeviceScreenState();
}

class _AdminDeviceScreenState extends State<AdminDeviceScreen> {
  final TextEditingController tagController = TextEditingController();
  List<DeviceModel> filteredDeviceList = [];
  List<UtilisateurModel> ListUsers = []; // Initialize a filtered list
  String? tagValue;

  @override
  void initState() {
    super.initState();
    // Call the function to fetch device data from the database when the screen is initialized
    Provider.of<DbService>(context, listen: false).fetchDevices();
    Provider.of<DbService>(context, listen: false).fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < narrowScreenWidthThreshold) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin:
                        const EdgeInsets.only(left: 20, top: 60, bottom: 10),
                    child: const Text(
                      "Screen User Web",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  child: const Text(
                    "Devices",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tagController,
                        decoration: InputDecoration(
                          labelText: 'Tag',
                          hintText: 'Enter a tag',
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          tagValue = tagController.text;
                          dbService.fetchDevicesByTag(
                              tagValue!); // Call the filter function when the button is pressed
                        });
                      },
                      child: const Icon(Icons.search, color: Colors.blue),
                    ),
                  ],
                ),
                Expanded(
                  child: Consumer<DbService>(
                    builder: (context, dbService, child) {
                      final deviceList =
                          tagValue != null && tagValue!.isNotEmpty
                              ? dbService.allDevices
                                  .where((device) => device.tag
                                      .toLowerCase()
                                      .contains(tagValue!.toLowerCase()))
                                  .toList()
                              : dbService.allDevices;
                      final ListUsers = dbService.allUsers;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: deviceList.length,
                        itemBuilder: (context, index) {
                          final device = deviceList[index];
                          return Card(
                            elevation: 8.2,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 6.0,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(64, 75, 96, 0.9),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10.0,
                                ),
                                leading: Container(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        width: 1.0,
                                        color: Colors.white24,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.bluetooth,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  device.mac,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: const Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          "Device",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AdminEditDevice(employee: device),
                                    ),
                                  ).then((refresh) {
                                    if (refresh == true) {
                                      // Reload the list of firmware (you can do this by fetching data again or using some other method)
                                      // You can call a function to fetch updated data here or use a state management approach to refresh the list.
                                      // For example, if you are using Provider, you can notify your Provider to rebuild.
                                      Provider.of<DbService>(context,
                                              listen: false)
                                          .fetchDevices();
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
