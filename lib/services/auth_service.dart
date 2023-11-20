<<<<<<< HEAD
import 'package:OTA/screens/homeScreen.dart';
import 'package:OTA/services/DbService.dart';
import 'package:OTA/utilis/utilis.dart';
=======



import 'package:com_sinses_ota/services/DbService.dart';
import 'package:com_sinses_ota/utilis/utilis.dart';
>>>>>>> origin/main
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
<<<<<<< HEAD
=======
  
>>>>>>> origin/main
  final SupabaseClient _supabase = Supabase.instance.client;
  final DbService _dbService = DbService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
<<<<<<< HEAD
  bool block = false ; 
=======
>>>>>>> origin/main

  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future registerEmployee(
      String email, String password, String name, BuildContext context) async {
    try {
      setIsLoading = true;
      if (email == "" || password == "") {
        throw ("All Fields are required");
      }
<<<<<<< HEAD
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
=======
      final AuthResponse response =
          await _supabase.auth.signUp(email: email, password: password,);
>>>>>>> origin/main
      if (response != null) {
        await _dbService.insertNewUser(email, name, response.user!.id);

        Utils.showSnackBar("Successfully registered !", context,
            color: Colors.green);
        await loginEmployee(email, password, context);
        Navigator.pop(context);
      }
    } catch (e) {
      setIsLoading = false;
<<<<<<< HEAD
      Utils.showSnackBar('User Already Registred ', context, color: Colors.red);
=======
      Utils.showSnackBar(e.toString(), context, color: Colors.red);
>>>>>>> origin/main
    }
  }

  Future loginEmployee(
      String email, String password, BuildContext context) async {
    try {
      setIsLoading = true;
      if (email == "" || password == "") {
        throw ("All Fields are required");
      }
      final AuthResponse response = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      setIsLoading = false;
    } catch (e) {
      setIsLoading = false;
<<<<<<< HEAD
      Utils.showSnackBar("Invalid Login Or Password ", context,
          color: Colors.red);
=======
      Utils.showSnackBar(e.toString(), context, color: Colors.red);
>>>>>>> origin/main
      print(e.toString());
    }
  }

  Future signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }

  static Future<bool> authenticateUser() async {
    //initialize Local Authentication plugin.
    final LocalAuthentication _localAuthentication = LocalAuthentication();

    //status of authentication.
    bool isAuthenticated = false;

    //check if device supports biometrics authentication.
    bool isBiometricSupported = await _localAuthentication.isDeviceSupported();

    List<BiometricType> biometricTypes =
        await _localAuthentication.getAvailableBiometrics();

    print(biometricTypes);

    //if device supports biometrics, then authenticate.
    if (isBiometricSupported) {
      try {
        isAuthenticated = await _localAuthentication.authenticate(
          localizedReason: 'To continue, you must complete the biometrics',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      } on PlatformException catch (e) {
        print(e);
      }
    }

    return isAuthenticated;
  }

  User? get currentUser => _supabase.auth.currentUser;
<<<<<<< HEAD
=======
  
>>>>>>> origin/main
}
