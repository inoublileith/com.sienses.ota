// import 'package:com_sinses_ota/models/users_model.dart';
// import 'package:com_sinses_ota/services/DbService.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class DetailDialog extends StatelessWidget {
//   final UtilisateurModel employee;

//   DetailDialog({required this.employee});
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController numberController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//      final dbService = Provider.of<DbService>(context);
//     final fullName = employee.name;
//     final email = employee.email;
//     final id = employee.id;
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Column(
//               children: [
//                 buildTextField("Full Name", nameController, fullName, false),
//                 buildTextField("Email", emailController, email, false),
//               ],
//             ),
//             // Text(
//             //   "Label 1: ${employee.name}", // Use the actual data you want to display
//             //   style: TextStyle(fontSize: 20),
//             // ),
//             // Text(
//             //   "Label 2: ${employee.email}", // Use the actual data you want to display
//             //   style: TextStyle(fontSize: 20),
//             // ),
//             SizedBox(height: 20),
//             Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//               OutlinedButton(
//                 onPressed: () {
//                   dbService.deleteUser(id, context).then((_) {
//                         Navigator.pop(
//                             context, true); // Pass a signal for refresh
//                       });
                      
//                 },
//                 child: Text("Delete",
//                     style: TextStyle(
//                         fontSize: 15, letterSpacing: 2, color: Colors.black)),
//                 style: OutlinedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 50),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20))),
//               ),
//                SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   final newName = nameController.text;
//                   final newEmail = emailController.text;

//                   if (newName.isNotEmpty && newEmail.isNotEmpty) {
//                     dbService.updateUser(id, newName, newEmail, context)
//                             .then((_) {
//                           Navigator.pop(
//                               context, true); // Pass a signal for refresh
//                         });
//                         ;
                     
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content:
//                             Text("Please fill in both Name and Email fields."),
//                       ),
//                     );
//                   }
//                 },
//                 child: Text("SAVE",
//                     style: TextStyle(
//                         fontSize: 15, letterSpacing: 2, color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                     primary: Colors.blue,
//                     padding: EdgeInsets.symmetric(horizontal: 50),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20))),
//               )
//             ]),
           
//           ],
//         ),
//       ),
//     );
//   }
//   Widget buildTextField(String labelText, TextEditingController controller,
//     String placehonder, bool isPasswordTextField) {
//   bool isObscurePassword = true;
//   return Padding(
//     padding: EdgeInsets.only(bottom: 30),
//     child: TextField(
//         controller: controller,
//         obscureText: isPasswordTextField ? isObscurePassword : false,
//         decoration: InputDecoration(
//             suffixIcon: isPasswordTextField
//                 ? IconButton(
//                     onPressed: () {
//                       // setState((){ isObscurePassword = ! isObscurePassword;});
//                     },
//                     icon: Icon(Icons.remove_red_eye, color: Colors.grey))
//                 : null,
//             contentPadding: EdgeInsets.only(bottom: 5),
//             labelText: labelText,
//             floatingLabelBehavior: FloatingLabelBehavior.always,
//             hintText: placehonder,
//             hintStyle: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey))),
//   );
// }
// }