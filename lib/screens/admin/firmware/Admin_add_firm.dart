import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminUploadScreen extends StatefulWidget {
  @override
  _AdminUploadScreen createState() => _AdminUploadScreen();
}

class _AdminUploadScreen extends State<AdminUploadScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Data and File Upload'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: versionController,
              decoration: InputDecoration(labelText: 'Version'),
            ),
            TextField(
              controller: tagController,
              decoration: InputDecoration(labelText: 'Tag'),
            ),
            ElevatedButton(
              onPressed: pickFile,
              child: Text('Choose a File'),
            ),
            if (selectedFilePath != null)
              Text('Selected File: $selectedFilePath'),
            ElevatedButton(
              onPressed: () {
                saveDataAndFilePath().then((_) {
                  Navigator.pop(context, true); // Pass a signal for refresh
                });
              },
              child: Text('Save Data and File Path'),
            ),
          ],
        ),
      ),
    );
  }
}
