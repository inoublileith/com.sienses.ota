
<<<<<<< HEAD
import 'package:OTA/screens/register_screen.dart';
import 'package:OTA/services/auth_service.dart';

=======
import 'package:com_sinses_ota/screens/register_screen.dart';
import 'package:com_sinses_ota/services/auth_service.dart';
>>>>>>> origin/main
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
<<<<<<< HEAD
     Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
=======
>>>>>>> origin/main

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: screenHeight / 3,
            width: screenWidth,
            decoration: const BoxDecoration(
<<<<<<< HEAD
                color: Color.fromARGB(225, 152, 36, 36),
=======
                color: Colors.indigo,
>>>>>>> origin/main
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(70))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
<<<<<<< HEAD
                Image.asset('assets/logoOTA.png', height: 200, width: 200),
                // Text("OTA",style: TextStyle(color: Colors.black,fontSize: 18),),
                SizedBox(
                  height: 5,
=======
                Image.asset('assets/logo.jpg', height: 80, width: 80),
                SizedBox(
                  height: 20,
>>>>>>> origin/main
                ),
               
                
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    label: Text("User Email ID"),
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
                Consumer<AuthService>(
                  builder: (context, authServiceProvider, child) {
                    return SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: authServiceProvider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                authServiceProvider.loginEmployee(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                    context);
                              },
                              style: ElevatedButton.styleFrom(
<<<<<<< HEAD
                                  backgroundColor: Color.fromARGB(225, 152, 36, 36),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: 
                              isDarkMode ?
                              const Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ):
                              const Text(
                                      "LOGIN",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black87),
                                    )
=======
                                  backgroundColor: Colors.indigo,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white70),
                              ),
>>>>>>> origin/main
                            ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
<<<<<<< HEAD
                    child: isDarkMode ? const Text("Are you a new User ? Register here",style: TextStyle(color: Colors.white),) : const Text("Are you a new User ? Register here",style: TextStyle(color: Colors.black87),))
=======
                    child: const Text("Are you a new User ? Register here"))
>>>>>>> origin/main
              ],
            ),
          ),
        ],
      ),
    );
  }
}
