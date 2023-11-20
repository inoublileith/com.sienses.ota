import 'package:OTA/models/device_model.dart';
import 'package:OTA/models/users_model.dart';
import 'package:OTA/services/DbService.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EditDevice extends StatefulWidget {
  final DeviceModel employee;

  const EditDevice({
    required this.employee,
  });

  @override
  _EditDeviceState createState() => _EditDeviceState();
}

class _EditDeviceState extends State<EditDevice> {
  bool isObscurePassword = true;
  TextEditingController MacController = TextEditingController();
  TextEditingController TagController = TextEditingController();
  String selectedUser = '';
  List<UtilisateurModel> ListUsers = [];
  List<String> userNames = [];
// Define a list of tag options

  @override
  void initState() {
    super.initState();
    Provider.of<DbService>(context, listen: false).fetchEmployees();
    // Extract user names from the list of users
    userNames = ListUsers.map((user) => user.name).toList();

    // Set the initial value of the dropdown to the device's user
    selectedUser = widget.employee.idUser;
  }

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);

    final tag = widget.employee.tag;
    final id = widget.employee.id;
    TagController.text = tag;
       Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    // Using below conditions because build can be called multiple times
    dbService.allUsers.isEmpty ? dbService.getAllusers() : null;
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Device BLE'),
          leading: IconButton(
            icon:isDarkMode? Icon(
              Icons.arrow_back,
              color: Colors.white,
            ): Icon(Icons.arrow_back,color: Colors.black38,),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, top: 20, right: 15),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child:isDarkMode ? Icon(
                          Icons.bluetooth,
                          size: 60,
                          color: Colors.white,
                        ): Icon(
                                  Icons.bluetooth,
                                  size: 60,
                                  color: Colors.black38,
                                )
                      ),
                      // Positioned(
                      //   bottom: 0,
                      //   right: 0,
                      //   child: Container(
                      //     height: 40,
                      //     width: 40,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       border: Border.all(width: 4, color: Colors.white),
                      //       color: Colors.blue,
                      //     ),
                      //     child: Icon(
                      //       Icons.edit,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // buildTextField("MAC", MacController, mac, false),
                buildTextField("Tag", TagController, tag, false),
                const Text("Select an Admin:"),
                dbService.allUsers.isEmpty
                    ? const LinearProgressIndicator()
                    : ValueListenableBuilder<String?>(
                        valueListenable: dbService.userchips,
                        builder: (context, value, _) {
                          return DropdownButton<String>(
                            value: value,
                            items:
                                dbService.allUsers.map((UtilisateurModel item) {
                              return DropdownMenuItem<String>(
                                value: item.id,
                                child: Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              );
                            }).toList(),
                            onChanged: (selectedValue) {
                              print('Selected user ID: $selectedValue');
                              dbService.userchips.value = selectedValue;
                            },
                          );
                        },
                      ),

                SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          dbService.deleteIntermediar(id, 1, context).then(
                              (value) =>
                                  dbService.deleteDevice(id, context).then((_) {
                                    Navigator.pop(context,
                                        true); // Pass a signal for refresh
                                  }));
                        },
                        child:isDarkMode ? Text("Delete",
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 2,
                                color: Colors.white)):Text("Delete",
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 2,
                                color: Colors.black)),
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // final newMac = MacController.text;
                          final newTag = TagController.text;

                          dbService.updateDevice(id, newTag, context).then((_) {
                            Navigator.pop(
                                context, true); // Pass a signal for refresh
                          });
                        },
                        child: Text("SAVE",
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 2,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                      )
                    ]),
              ],
            ),
          ),
        ));
  }
}

Widget buildTextField(String labelText, TextEditingController controller,
    String placehonder, bool isPasswordTextField) {
  bool isObscurePassword = true;
  return Padding(
    padding: EdgeInsets.only(bottom: 30),
    child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      // setState((){ isObscurePassword = ! isObscurePassword;});
                    },
                    icon: Icon(Icons.remove_red_eye, color: Colors.grey))
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            // hintText: placehonder,
            hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey))),
  );
}
