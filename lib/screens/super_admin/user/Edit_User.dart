import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:OTA/models/users_model.dart';
import 'package:OTA/services/DbService.dart';

class DetailPage extends StatefulWidget {
  final UtilisateurModel employee;

  DetailPage({required this.employee});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  Map<String, int> roleValues = {
    'admin': 2,
    'user': 3,
  };

  @override
  void initState() {
    super.initState();
    nameController.text = widget.employee.name;
    emailController.text = widget.employee.email;
  }

  @override
  Widget build(BuildContext context) {
    
    final dbService = Provider.of<DbService>(context);
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        leading: IconButton(
          icon:isDarkMode ? const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ): const Icon(Icons.arrow_back ,color: Colors.black38,),
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
                        Icons.person_2,
                        size: 60,
                        color: Colors.white,
                      ):Icon(
                        Icons.person_2,
                        size: 60,
                        color: Colors.black,
                      ) 
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Full Name", nameController),
              const Text("Select a Role:"),
              SizedBox(
                width: double.infinity,
                child: DropdownButton(
                  value: dbService.role,
                  items: roleValues.keys.map((role) {
                    return DropdownMenuItem(
                      value: roleValues[role],
                      child: Text(
                        role,
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                  onChanged: (selectedValue) {
                    setState(() {
                      dbService.role = selectedValue;
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
                      dbService
                          .updateDeviceWithIdUser(widget.employee.id, context)
                          .then((value) => dbService
                              .updateFirmsWithIdUser(
                                  widget.employee.id, context)
                              .then((value) => dbService
                                      .deleteUser(widget.employee.id,
                                          widget.employee.userID, context)
                                      .then((_) {
                                    Navigator.pop(context,
                                        true);
                                  })));
                    },
                    child: isDarkMode ? Text("Delete",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.white)): Text("Delete",
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
                      final newName = nameController.text;

                      if (newName.isNotEmpty) {
                        dbService
                            .updateUser(widget.employee.id, newName, context)
                            .then((_) {
                          Navigator.pop(
                              context, true); // Pass a signal for refresh
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Please fill in the Full Name field."),
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
