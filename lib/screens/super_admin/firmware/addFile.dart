import 'package:OTA/models/firm_model.dart';
import 'package:OTA/models/users_model.dart';
import 'package:OTA/services/DbService.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddFirm extends StatefulWidget {


  @override
  _AddFirmState createState() => _AddFirmState();
}

class _AddFirmState extends State<AddFirm> {
  bool isObscurePassword = true;
  TextEditingController VersionController = TextEditingController();
  TextEditingController TagController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
final SupabaseClient supabase = Supabase.instance.client;

  TextEditingController versionController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  String? selectedFilePath;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = result.files.first;
      setState(() {
        selectedFilePath = file.path;
      });
    } else {
      print('File selection canceled by the user.');
    }
  }

  Future<void> saveDataAndFilePath() async {
    if (selectedFilePath == null) {
      print('Please choose a file first.');
      return;
    }

    final metadata = {
      'version': versionController.text,
      'Tag': tagController.text,
      'file_path': selectedFilePath, // Store the file path in the table
    };

    // Store the metadata in your Supabase table (replace 'your-table-name').
    final result = await supabase.from('Firmware').upsert([metadata]);

    if (result != null && result.error == null) {
      print('Data and file path uploaded successfully.');
      versionController.clear();
      tagController.clear();
      setState(() {
        selectedFilePath = null;
      });
    } else if (result != null) {
      print('Error storing data and file path: ${result.error!.message}');
    } else {
      print('Unknown error: Result is null.');
    }
  }


  @override
  Widget build(BuildContext context) {
    // final dbService = Provider.of<DbService>(context);



    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Firmware'),
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
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                          shape: BoxShape.circle,
                          
                        ),
                        child: Icon(
                          Icons.blur_on,
                          size: 60,
                          color: Colors.black,
                        ),
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

                SizedBox(height: 30),
                buildTextField("Version", versionController,  false),
                buildTextField("Tag", tagController, false),
                SizedBox(height: 20,),
                ElevatedButton(
              onPressed: pickFile,
              child: Text('Choose a File'),
            ),
            if (selectedFilePath != null)
              Text('Selected File: $selectedFilePath'),
             
               
          
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                           Navigator.pop(context, true);
                         
                        },
                        child: Text("Cancel",
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
                          final tag = tagController.text; 
                          final selected =  selectedFilePath;
                          if (selected !=null){
saveDataAndFilePath().then((_) {
                              Navigator.pop(
                                  context, true); // Pass a signal for refresh
                            });
                          }
                          else {
                             ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Please fill file box "),
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
     bool isPasswordTextField) {
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
