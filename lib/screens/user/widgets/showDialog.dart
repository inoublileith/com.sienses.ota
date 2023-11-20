<<<<<<< HEAD
//  import 'package:com_sinses_ota/screens/user/scan_screen.dart';
// import 'package:flutter/material.dart';

// void showCustomDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Warning'),
//           content: Text('Do you want to Stop Progress ?'),
//           actions: <Widget>[
//             TextButtoan(
//               child: Text('No'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//             TextButton(
//               child: Text('Yes'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 // Navigate back to the UserScreen
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => const ScanScreen(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
=======
 import 'package:com_sinses_ota/screens/user/scan_screen.dart';
import 'package:flutter/material.dart';

void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Do you want to Stop Progress ?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate back to the UserScreen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ScanScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
>>>>>>> origin/main


