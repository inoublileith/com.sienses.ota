// Example structure for the About screen

import 'package:OTA/models/users_model.dart';
import 'package:OTA/services/DbService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: FutureBuilder<UtilisateurModel>(
          future: Provider.of<DbService>(context, listen: false).getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Loading state
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              // Error state
              return Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              // Data not available state
              return Scaffold(
                body: Center(child: Text('User data not available')),
              );
            } else {
              // Data available state
              UtilisateurModel userModel = snapshot.data!;
              nameController.text = userModel.name;
              emailController.text = userModel.email;

              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Container(
                        //   margin: const EdgeInsets.only(top: 20),
                        //   alignment: Alignment.topRight,
                        //   child: TextButton.icon(
                        //     onPressed: () {
                        //       Provider.of<AuthService>(context, listen: false)
                        //           .signOut();
                        //     },
                        //     icon: const Icon(Icons.logout),
                        //     label: const Text("Sign Out"),
                        //   ),
                        // ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(225, 152, 36, 36),
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
                        Text(
                          "User ID : ${userModel.id}",
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            label: Text("Full name"),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // TextField(
                        //   controller: emailController,
                        //   decoration: const InputDecoration(
                        //     label: Text("Email"),
                        //     border: OutlineInputBorder(),
                        //   ),
                        // ),
                        const SizedBox(height: 15),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Provider.of<DbService>(context, listen: false)
                                  .updateProfil(
                                      nameController.text.trim(), context);
                              Provider.of<DbService>(context, listen: false)
                                  .getUserData();
                            },
                            child: const Text(
                              "Update Profile",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
