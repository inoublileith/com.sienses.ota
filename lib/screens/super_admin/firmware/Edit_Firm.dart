<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:OTA/models/firm_model.dart';
import 'package:OTA/models/users_model.dart';
import 'package:OTA/services/DbService.dart';
=======
import 'package:com_sinses_ota/models/firm_model.dart';
import 'package:com_sinses_ota/models/users_model.dart';
import 'package:com_sinses_ota/screens/super_admin/user/users_screen.dart';
import 'package:com_sinses_ota/services/DbService.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
>>>>>>> origin/main

class EditFirm extends StatefulWidget {
  final FirmModel employee;

  EditFirm({required this.employee});

  @override
  _EditFirmState createState() => _EditFirmState();
}

class _EditFirmState extends State<EditFirm> {
<<<<<<< HEAD
  TextEditingController versionController = TextEditingController();
  TextEditingController tagController = TextEditingController();
=======
  bool isObscurePassword = true;
  TextEditingController VersionController = TextEditingController();
  TextEditingController TagController = TextEditingController();
>>>>>>> origin/main

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    versionController.text = widget.employee.version;
    tagController.text = widget.employee.tag;
=======
>>>>>>> origin/main
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
       Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final dbService = Provider.of<DbService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit FirmWare'),
        leading: IconButton(
          icon:isDarkMode ? Icon(
            Icons.arrow_back,
            color: Colors.white,
          ): Icon(Icons.arrow_back ,color: Colors.black38,),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
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
                        Icons.blur_on,
                        size: 60,
                        color: Colors.white,
                      ): Icon(
                                Icons.blur_on,
                                size: 60,
                                color: Colors.black,
                              ) 
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Version", versionController),
              buildTextField("Tag", tagController),
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
                      dbService
                          .deleteIntermediar(widget.employee.id, 2, context)
                          .then((value) => dbService
                                  .deleteFirm(widget.employee.id, context)
                                  .then((_) {
                                Navigator.pop(context, true);
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
                      final newName = versionController.text;
                      final newEmail = tagController.text;

                      if (newName.isNotEmpty && newEmail.isNotEmpty) {
                        dbService
                            .updateFirm(
                                widget.employee.id, newName, newEmail, context)
                            .then((_) {
                          Navigator.pop(context, true);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Please fill in both Version and Tag fields."),
                          ),
                        );
                      }
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
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
=======
    final dbService = Provider.of<DbService>(context);
    final version = widget.employee.version;
    final tag = widget.employee.tag;
    final id = widget.employee.id;
    dbService.allUsers.isEmpty ? dbService.getAllusers() : null;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit FirmWare'),
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
                                  color: Colors.white.withOpacity(0.1))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2021/04/16/10/19/chip-6183191_1280.png'))),
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
                              color: Colors.blue),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                buildTextField("Version", VersionController, version, false),
                buildTextField("Tag", TagController, tag, false),
                 const Text("Select a User:"),
                dbService.allUsers.isEmpty
                    ? const LinearProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: DropdownButton(
                          value: dbService.UserChips ??
                              dbService.allUsers.first.id,
                          items:
                              dbService.allUsers.map((UtilisateurModel item) {
                            return DropdownMenuItem(
                                value: item.id,
                                child: Text(
                                  item.name,
                                  style: const TextStyle(fontSize: 20),
                                ));
                          }).toList(),
                          onChanged: (selectedValue) {
                            dbService.UserChips = selectedValue;
                          },
                        ),
                      ),
                SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {dbService.updateIntermediarefirms(id,context).then((value) =>   dbService.deleteFirm(id, context).then((_) {
                            Navigator.pop(
                                context, true ); // Pass a signal for refresh
                          }));
                         
                        },
                        child: Text("Delete",
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
                          final newName = VersionController.text;
                          final newEmail = TagController.text;

                          if (newName.isNotEmpty && newEmail.isNotEmpty) {
                            dbService.updateFirm(
                                id, newName, newEmail, context)
                                .then((_) {
                              Navigator.pop(
                                  context, true); // Pass a signal for refresh
                            });
                            
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Please fill in both Name and Email fields."),
                              ),
                            );
                          }
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
            hintText: placehonder,
            hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey))),
  );
}
>>>>>>> origin/main
