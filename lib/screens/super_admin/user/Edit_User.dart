import 'package:com_sinses_ota/models/users_model.dart';
import 'package:com_sinses_ota/screens/super_admin/user/users_screen.dart';
import 'package:com_sinses_ota/services/DbService.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final UtilisateurModel employee;

  DetailPage({required this.employee});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isObscurePassword = true;
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
  }

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);
    final fullName = widget.employee.name;
    final email = widget.employee.email;
    final id = widget.employee.id;

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Employee'),
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
                                    'https://cdn.pixabay.com/photo/2016/12/19/21/36/woman-1919143_1280.jpg'))),
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
                buildTextField("Full Name", nameController, fullName, false),
                buildTextField("Email", emailController, email, false),
               const Text("Select a Role:"),
               SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value:
                        roleValues['admin'], // Set the default value to 'admin'
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
                      // Use the selectedValue as the role value
                      dbService.role = selectedValue  ;
                    },
                  ),
                ),
                SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {dbService.updateDeviceWithIdUser(id, context).then((value) => dbService.updateFirmsWithIdUser(id , context ).then((value) => 
                         dbService
                                          .deleteUser(id, context)
                                          .then((_) {
                                        Navigator.pop(context,
                                            true); // Pass a signal for refresh
                                      })));
                         
                          
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
                          final newName = nameController.text;
                          final newEmail = emailController.text;
                

                          if (newName.isNotEmpty && newEmail.isNotEmpty) {
                            dbService.updateUser(
                                id as String, newName, newEmail, context)
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
