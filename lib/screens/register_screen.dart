<<<<<<< HEAD
import 'package:OTA/services/auth_service.dart';
import 'package:OTA/utilis/utilis.dart';
=======
import 'package:com_sinses_ota/services/auth_service.dart';
import 'package:com_sinses_ota/utilis/utilis.dart';
>>>>>>> origin/main

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
     Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(225, 152, 36, 36),
=======
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final Map<String, dynamic> attendanceFilter = {
      // Define your filter criteria here, for example:
      'id': {'_eq': 123}, // Delete the attendance record with ID 123.
    };
    const int atMost = 3;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
>>>>>>> origin/main
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
<<<<<<< HEAD
            height: screenHeight / 3,
            width: screenWidth,
            decoration: const BoxDecoration(
                color: Color.fromARGB(225, 152, 36, 36),
=======
            height: screenHeight / 4,
            width: screenWidth,
            decoration: const BoxDecoration(
                color: Colors.indigo,
>>>>>>> origin/main
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(70))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
<<<<<<< HEAD
                // Text(
                //   "OTA",
                //   style: TextStyle(color: Colors.black, fontSize: 18),
                // ),
                Image.asset(
                  'assets/logoOTA.png',
                  width: 200,
                  height: 200,
                ),
                
=======
                Image.asset(
                  'assets/logo.jpg',
                  width: 80,
                  height: 80,
                ),
>>>>>>> origin/main
                SizedBox(
                  height: 20,
                ),
             
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
<<<<<<< HEAD
                    label: Text("User Email ID"),
=======
                    label: Text("Employee Email ID"),
>>>>>>> origin/main
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  controller: _emailController,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: const InputDecoration(
                    label: Text("Password"),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: const InputDecoration(
                    label: Text("Name"),
                    prefixIcon: Icon(Icons.face),
                    border: OutlineInputBorder(),
                  ),
                  controller: _nameController,
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer<AuthService>(
                  builder: (context, authServiceProvider, child) {
                    return SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: authServiceProvider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                final email = _emailController.text.trim();
                                final password =
                                    _passwordController.text.trim();
                                final name = _nameController.text.trim();

                                if (email.isEmpty ||
                                    password.isEmpty ||
                                    name.isEmpty) {
                                  Utils.showSnackBar(
                                      "Email and password are required.",
                                      context,
                                      color: Colors.red);
                                } else {
                                  authServiceProvider.registerEmployee(email, password, name, context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
<<<<<<< HEAD
                                  backgroundColor: Color.fromARGB(225, 152, 36, 36),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child:isDarkMode ?
                               const Text(
                                "REGISTER",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white,
                                ),
                              ):
                              const Text(
                                "REGISTER",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black87,
                                ),

                            )
                    ));
                                    },
=======
                                  // backgroundColor: Colors.indigo,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Text(
                                "REGISTER",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.indigo),
                              ),
                            ),
                    );
                  },
>>>>>>> origin/main
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
