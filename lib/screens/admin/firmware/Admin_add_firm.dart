import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminUploadScreen extends StatefulWidget {
  final String userId;

  AdminUploadScreen({required this.userId});

  @override
  _AdminUploadScreenState createState() => _AdminUploadScreenState();
}

class _AdminUploadScreenState extends State<AdminUploadScreen> {
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
      'file_path': selectedFilePath,
      'Id_user': widget.userId
    };

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
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Firmware'),
          leading: IconButton(
            icon: isDarkMode
                ? Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )
                : Icon(
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
                        child: isDarkMode
                            ? Icon(
                                Icons.blur_on,
                                size: 60,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.blur_on,
                                size: 60,
                                color: Colors.black,
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                buildTextField("Version", versionController, false),
                buildTextField("Tag", tagController, false),
                SizedBox(
                  height: 20,
                ),
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
                        child: isDarkMode
                            ? Text("Cancel",
                                style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 2,
                                    color: Colors.white))
                            : Text("Cancel",
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
                          final selected = selectedFilePath;
                          if (selected != null) {
                            saveDataAndFilePath().then((_) {
                              Navigator.pop(context, true);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please fill file box "),
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
