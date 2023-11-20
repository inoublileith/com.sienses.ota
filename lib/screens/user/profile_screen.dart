import 'package:flutter/material.dart';
import 'package:ota/models/users_model.dart';
import 'package:provider/provider.dart';
import 'package:ota/services/DbService.dart';
import 'package:ota/services/auth_service.dart';

const Widget divider = SizedBox(height: 10);

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<UtilisateurModel>(
          future: dbService.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final user = snapshot.data;
              nameController.text = user?.name ?? '';
              emailController.text = user?.email ?? '';

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.redAccent,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text("User ID : ${user?.user ?? 'N/A'}"),
                    const SizedBox(height: 30),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Full name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                   
                    const SizedBox(height: 15),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          dbService.updateProfil(nameController.text.trim(), emailController.text.trim(), context);
                        },
                        child: const Text(
                          "Update Profile",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
