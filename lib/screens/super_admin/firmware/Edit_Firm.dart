import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:OTA/models/firm_model.dart';
import 'package:OTA/models/users_model.dart';
import 'package:OTA/services/DbService.dart';

class EditFirm extends StatefulWidget {
  final FirmModel employee;

  EditFirm({required this.employee});

  @override
  _EditFirmState createState() => _EditFirmState();
}

class _EditFirmState extends State<EditFirm> {
  TextEditingController versionController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    versionController.text = widget.employee.version;
    tagController.text = widget.employee.tag;
  }

  @override
  Widget build(BuildContext context) {
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
