<<<<<<< HEAD
import 'package:OTA/models/users_model.dart';
import 'package:OTA/services/DbService.dart';
=======
// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:com_sinses_ota/services/DbService.dart';
import 'package:com_sinses_ota/services/auth_service.dart';
>>>>>>> origin/main

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

<<<<<<< HEAD

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UtilisateurModel>(
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
                    Text("User ID : ${userModel.id}",style: TextStyle(fontSize: 15),),
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
                              .updateProfil(nameController.text.trim(),
                                  context);
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
    );
=======
const Widget divider = SizedBox(height: 10);

// If screen content width is greater or equal to this value, the light and dark
// color schemes will be displayed in a column. Otherwise, they will
// be displayed in a row.
const double narrowScreenWidthThreshold = 400;
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);
    // Using below conditions because build can be called multiple times
   
    nameController.text.isEmpty
        ? nameController.text = dbService.userModel?.name ?? ''
        : null;
    return Expanded(
        child: Scaffold(
            body: Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.topRight,
              child: TextButton.icon(
                  onPressed: () {
                    Provider.of<AuthService>(context, listen: false).signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Sign Out")),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.redAccent),
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text("User ID : ${dbService.userModel?.userID}"),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  label: Text("Full name"), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15,
            ),
             TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  label: Text("email"), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15,
            ),
            
           
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // dbService.updateProfil(nameController.text.trim(),emailController.text.trim(), context);
                  dbService.getUserData();
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
    )));
>>>>>>> origin/main
  }
}
