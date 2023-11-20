import 'package:flutter/material.dart';
import 'package:ota/screens/components/NavigationDrawer/MailDestination.dart';
import 'package:ota/screens/homeScreen.dart';
import 'package:ota/screens/user/profile_screen.dart';
import 'package:ota/services/auth_service.dart';
import 'package:provider/provider.dart';

class NavigationDrawerSection extends StatefulWidget {
  const NavigationDrawerSection({Key? key});
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

        _navigateToScreen(context, destinations[selectedIndex].label);
      },
      selectedIndex: navDrawerIndex,
      children: <Widget>[
       
        ...destinations.map((destination) {
          return NavigationDrawerDestination(
            label: Text(destination.label),
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
            onTap: () => _navigateToScreen(context, destination.label),
          );
        }),
        const SizedBox(height: 80),
       
      ],
    );
  }

  void _navigateToScreen(BuildContext context, String label) {

    switch (label) {
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Expanded(child:   ProfileScreen(),)),
        );
        break;
      case 'About':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen()),
        );
        break;
      case 'Favorites':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritesScreen()),
        );
        break;
      case 'Trash':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TrashScreen()),
        );
        break;
      case 'LogOut':
         Provider.of<AuthService>(context, listen: false)
                              .signOut();
        break;
    }
  }
}

class NavigationDrawerDestination extends StatelessWidget {
  final Text label;
  final Widget icon;
  final Widget selectedIcon;
  final VoidCallback onTap;

  NavigationDrawerDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: label,
      leading: icon,
      onTap: onTap,
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final List<Widget> children;

  NavigationDrawer({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
        const SizedBox( height:  20,),
          Expanded(
            child: ListView.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                return children[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Screen'),
//       ),
//       body: Center(
//         child: Text('Profile Screen Content'),
//       ),
//     );
//   }
// }

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Screen'),
      ),
      body: Center(
        child: Text('About Screen Content'),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Screen'),
      ),
      body: Center(
        child: Text('Favorites Screen Content'),
      ),
    );
  }
}

class TrashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trash Screen'),
      ),
      body: Center(
        child: Text('Trash Screen Content'),
      ),
    );
  }
}

// class LogOutScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('LogOut Screen'),
//       ),
//       body: Center(
//         child: Text('LogOut Screen Content'),
//       ),
//     );
//   }

