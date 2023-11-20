<<<<<<< HEAD
import 'package:OTA/screens/admin/device/Edit_Admin_Device.dart';
import 'package:OTA/services/DbService.dart';
=======
import 'package:com_sinses_ota/models/device_model.dart';
import 'package:com_sinses_ota/models/users_model.dart';
import 'package:com_sinses_ota/screens/admin/device/Edit_Admin_Device.dart';
import 'package:com_sinses_ota/screens/homeScreen.dart';
import 'package:com_sinses_ota/screens/super_admin/user/Edit_User.dart';
import 'package:com_sinses_ota/screens/super_admin/device/edit_device.dart';
import 'package:com_sinses_ota/services/DbService.dart';

>>>>>>> origin/main
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

<<<<<<< HEAD
const double narrowScreenWidthThreshold = 100;

// ... (your existing imports)
=======
const Widget divider = SizedBox(height: 10);

// If screen content width is greater or equal to this value, the light and dark
// color schemes will be displayed in a column. Otherwise, they will
// be displayed in a row.
const double narrowScreenWidthThreshold = 100;
>>>>>>> origin/main

class AdminDeviceScreen extends StatefulWidget {
  const AdminDeviceScreen({Key? key}) : super(key: key);

  @override
  _AdminDeviceScreenState createState() => _AdminDeviceScreenState();
}

class _AdminDeviceScreenState extends State<AdminDeviceScreen> {
  final TextEditingController tagController = TextEditingController();
<<<<<<< HEAD
  String? tagValue;
  bool isFilterActive = false;

  List<String> selectedDeviceIds = []; // Store selected device IDs
=======
  List<DeviceModel> filteredDeviceList = [];
  List<UtilisateurModel> ListUsers = []; // Initialize a filtered list
  String? tagValue;
>>>>>>> origin/main

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    final dbService = Provider.of<DbService>(context, listen: false);
    dbService.fetchDevices(); // Fetch all devices when the screen initializes.
=======
    // Call the function to fetch device data from the database when the screen is initialized
    Provider.of<DbService>(context, listen: false).fetchDevices();
    Provider.of<DbService>(context, listen: false).fetchEmployees();
>>>>>>> origin/main
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final dbService = Provider.of<DbService>(context);

=======
>>>>>>> origin/main
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
<<<<<<< HEAD
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.black38),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: tagController,
                                onChanged: (value) {
                                  setState(() {
                                    tagValue = value;
                                    if (tagValue!.isEmpty) {
                                      isFilterActive = false;
                                      dbService.fetchDevices();
                                    } else {
                                      isFilterActive = true;
                                      dbService.fetchDevicesByTag(tagValue!);
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search by tag',
                                  hintStyle: TextStyle(color: Colors.black38),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextField(
                //         controller: tagController,
                //         onChanged: (value) {
                //           setState(() {
                //             tagValue = value;
                //             if (tagValue!.isEmpty) {
                //               isFilterActive = false;
                //               dbService.fetchDevices();
                //             } else {
                //               isFilterActive = true;
                //               dbService.fetchDevicesByTag(tagValue!);
                //             }
                //           });
                //         },
                //         decoration: InputDecoration(
                //           labelText: 'Tag',
                //           hintText: 'Enter a tag',
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // Display the clear filter and add firm buttons
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          tagController.clear();
                          tagValue = null;
                          isFilterActive = false;
                          dbService.fetchDevices();
                        });
                      },
                      child: const Text('Clear All'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          for (final device in dbService.allDevices) {
                            device.isSelected = true;
                          }
                        });
                      },
                      child: const Text('Check All '),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDevices = dbService.allDevices
                            .where((device) => device.isSelected)
                            .toList();

                        if (selectedDevices.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('No devices selected'),
                                content: Text(
                                  'Please select at least one device to associate with a firm.',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          int? selectedFirmId; // Initialize as null

                          selectedFirmId = await showDialog<int>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Select a Firm'),
                                content: Column(
                                  children: dbService.allFirms.map((firm) {
                                    return RadioListTile<int>(
                                      title: Text(firm.version),
                                      value: int.parse(firm
                                          .id), // Use the id of the firm as the value
                                      groupValue:
                                          selectedFirmId, // Use selectedFirmId as the groupValue
                                      onChanged: (value) {
                                        setState(() {
                                          selectedFirmId =
                                              value; // Update the selectedFirmId value
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () async {
                                      if (selectedFirmId != null) {
                                        print(
                                            'Selected Firm ID: $selectedFirmId');
                                        print(selectedDeviceIds);
                                        // Call the function to create entries in the firmsdevice table
                                        await dbService.createFirmsDevices(
                                            selectedDeviceIds,
                                            selectedFirmId.toString(),
                                            context);
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Text('Add Firms'),
=======
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
>>>>>>> origin/main
                    ),
                  ],
                ),
                Expanded(
                  child: Consumer<DbService>(
                    builder: (context, dbService, child) {
<<<<<<< HEAD
                      final deviceList = isFilterActive
                          ? dbService.allDevices
                              .where((device) => device.tag
                                  .toLowerCase()
                                  .contains(tagValue!.toLowerCase()))
                              .toList()
                          : dbService.allDevices;

=======
                      final deviceList =
                          tagValue != null && tagValue!.isNotEmpty
                              ? dbService.allDevices
                                  .where((device) => device.tag
                                      .toLowerCase()
                                      .contains(tagValue!.toLowerCase()))
                                  .toList()
                              : dbService.allDevices;
                      final ListUsers = dbService.allUsers;
>>>>>>> origin/main
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
<<<<<<< HEAD
                                trailing: IconButton(
                                  icon: device.isSelected
                                      ? Icon(Icons.check_box)
                                      : Icon(Icons.check_box_outline_blank),
                                  onPressed: () {
                                    setState(() {
                                      device.isSelected = !device.isSelected;
                                      // Update the selectedDeviceIds list
                                      if (device.isSelected) {
                                        selectedDeviceIds.add(device.id);
                                      } else {
                                        selectedDeviceIds.remove(device.id);
                                      }
                                    });
                                  },
=======
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                  size: 30.0,
>>>>>>> origin/main
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
<<<<<<< HEAD
=======
                                      // Reload the list of firmware (you can do this by fetching data again or using some other method)
                                      // You can call a function to fetch updated data here or use a state management approach to refresh the list.
                                      // For example, if you are using Provider, you can notify your Provider to rebuild.
>>>>>>> origin/main
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
<<<<<<< HEAD
                ),
=======
                )
>>>>>>> origin/main
              ],
            );
          }
        },
      ),
    );
  }
}
