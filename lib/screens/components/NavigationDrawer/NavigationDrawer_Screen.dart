
import 'package:com_sinses_ota/screens/components/NavigationDrawer/MailDestination.dart';
import 'package:com_sinses_ota/screens/homeScreen.dart';
import 'package:com_sinses_ota/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationDrawerSection extends StatefulWidget {
  const NavigationDrawerSection({super.key});
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
      ],
    );
  }
}

class BarChartWidget {
}
