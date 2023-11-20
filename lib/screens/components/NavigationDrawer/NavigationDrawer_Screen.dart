<<<<<<< HEAD
import 'package:OTA/screens/MyProfile.dart';
import 'package:OTA/screens/about_Secreen.dart';
import 'package:OTA/screens/components/NavigationDrawer/MailDestination.dart';
import 'package:OTA/screens/user/profile_screen.dart';
// import 'package:OTA/screens/inbox_screen.dart'; // Import your InboxScreen
// import 'package:OTA/screens/outbox_screen.dart'; // Import your OutboxScreen
// import 'package:OTA/screens/favorites_screen.dart'; // Import your FavoritesScreen
// import 'package:OTA/screens/trash_screen.dart'; // Import your TrashScreen
import 'package:OTA/services/auth_service.dart';
=======

import 'package:com_sinses_ota/screens/components/NavigationDrawer/MailDestination.dart';
import 'package:com_sinses_ota/screens/homeScreen.dart';
import 'package:com_sinses_ota/services/auth_service.dart';
>>>>>>> origin/main
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationDrawerSection extends StatefulWidget {
<<<<<<< HEAD
  const NavigationDrawerSection({Key? key}) : super(key: key);

=======
  const NavigationDrawerSection({super.key});
>>>>>>> origin/main
  @override
  State<NavigationDrawerSection> createState() =>
      _NavigationDrawerSectionState();
}

class _NavigationDrawerSectionState extends State<NavigationDrawerSection> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (selectedIndex) {
        setState(() {
          navDrawerIndex = selectedIndex;
        });
<<<<<<< HEAD

        // Navigate to different screens based on the selected index
        switch (selectedIndex) {
          case 0:
            // Inbox
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  MyProfile()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  AboutScreen()),
            );
            break;
          case 2:
            // Favorites
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => FavoritesScreen()),
            // );
            break;
          case 3:
            // Trash
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => TrashScreen()),
            // );
            break;
          case 4:
            // LogOut
            Provider.of<AuthService>(context, listen: false).signOut();
            break;
          // Add more cases for other destinations if needed
        }
=======
>>>>>>> origin/main
      },
      selectedIndex: navDrawerIndex,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Mail',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ...destinations.map((destination) {
          return NavigationDrawerDestination(
            label: Text(destination.label),
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
          );
        }),
        const Divider(indent: 28, endIndent: 28),
<<<<<<< HEAD
        const SizedBox(height: 80),
       
=======
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Labels',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
       ...labelDestinations.map((destination) {
          return InkWell(
            onTap: () {
           
            },
            child: ListTile(
              leading: destination.icon,
              title: Text(destination.label),
            ),
          );
        }),
        const SizedBox(height: 80),
        Container(
          margin: const EdgeInsets.only(top: 20),
          alignment: Alignment.topRight,
          child: TextButton.icon(
              onPressed: () {
                Provider.of<AuthService>(context, listen: false).signOut();
                // dbService.isAdmin();
              },
              icon: const Icon(Icons.logout),
              label: const Text("Sign Out")),
        ),
>>>>>>> origin/main
      ],
    );
  }
}

<<<<<<< HEAD
class BarChartWidget {}
=======
class BarChartWidget {
}
>>>>>>> origin/main
