import 'package:flutter/material.dart';
import 'package:ota/models/device_model.dart';
import 'package:ota/models/users_model.dart';
import 'package:ota/services/DbService.dart';
import 'package:provider/provider.dart';

class AdminEditDevice extends StatefulWidget {
  final DeviceModel employee;

  const AdminEditDevice({
    required this.employee,
  });

  @override
  _AdminEditDeviceState createState() => _AdminEditDeviceState();
}

class _AdminEditDeviceState extends State<AdminEditDevice> {
  TextEditingController macController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  String selectedUser = '';
  List<UtilisateurModel> listUsers = [];
  List<String> userNames = [];

  @override
  void initState() {
    super.initState();
    macController.text = widget.employee.mac;
    tagController.text = widget.employee.tag;
    Provider.of<DbService>(context, listen: false).fetchEmployees();
    userNames = listUsers.map((user) => user.name).toList();
    selectedUser = widget.employee.idUser;
  }

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);
    final id = widget.employee.id;

    dbService.allUsers.isEmpty ? dbService.getAllusers() : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Device BLE'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
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
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            'https://cdn.pixabay.com/photo/2020/06/16/21/07/bluetooth-5307291_1280.png',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Colors.white),
                          color: Colors.blue,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              buildTextField("MAC", macController),
              buildTextField("Tag", tagController),
              const Text("Select a User:"),
              dbService.allUsers.isEmpty
                  ? const LinearProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: DropdownButton(
                        value: selectedUser,
                        items: listUsers.map((UtilisateurModel item) {
                          return DropdownMenuItem(
                            value: item.id,
                            child: Text(
                              item.name,
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                        onChanged: (selectedValue) {
                          setState(() {
                            selectedUser = selectedValue.toString();
                          });
                        },
                      ),
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
                                Navigator.pop(
                                    context, true); // Pass a signal for refresh
                              }));
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final newMac = macController.text;
                      final newTag = tagController.text;

                      if (newMac.isNotEmpty && newTag.isNotEmpty) {
                        dbService.updateDevice(id, newTag, context).then((_) {
                          Navigator.pop(
                              context, true); // Pass a signal for refresh
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Please fill in both MAC and Tag fields."),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
