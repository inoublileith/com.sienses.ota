
import 'package:flutter/material.dart';
import 'package:ota/screens/components/NavigationBar/ComponentDec_Screen.dart';
import 'package:ota/screens/homeScreen.dart';



class NavigationBars extends StatefulWidget {
  const NavigationBars({
    Key? key,
    this.onSelectItem,
    required this.selectedIndex,
    required this.isExampleBar,
    this.isBadgeExample = false,
  }) : super(key: key);

  final void Function(int)? onSelectItem;
  final int selectedIndex;
  final bool isExampleBar;
  final bool isBadgeExample;

  @override
  State<NavigationBars> createState() => _NavigationBarsState();
}

class _NavigationBarsState extends State<NavigationBars> {
  int selectedIndex = 0; // Initialize with a default value
  List<NavigationDestination> appBarDestinations = [];
  late Future<String> admin;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    admin = isAdmin();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: admin,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
           int test = int.parse(snapshot.data ?? "1");

          // Initialize destinations based on admin status
          List<NavigationDestination> appBarDestinations = [];
          
          if (test == 1) {
            appBarDestinations = [
              NavigationDestination(
                tooltip: '',
                icon: Icon(Icons.person_4),
                label: 'Users',
                selectedIcon: Icon(Icons.person_4_outlined),
              ),
              NavigationDestination(
                tooltip: '',
                icon: Icon(Icons.bluetooth),
                label: 'Devices',
                selectedIcon: Icon(Icons.bluetooth_outlined),
              ),
              NavigationDestination(
                tooltip: '',
                icon: Icon(Icons.blur_on),
                label: 'FirmWare',
                selectedIcon: Icon(Icons.blur_on_outlined),
              ),
            ];
          } 
          else if (test == 2) {
            appBarDestinations = [
              NavigationDestination(
                tooltip: '',
                icon: Icon(Icons.bluetooth),
                label: 'Devices',
                selectedIcon: Icon(Icons.bluetooth_outlined),
              ),
              NavigationDestination(
                tooltip: '',
                icon: Icon(Icons.blur_on),
                label: 'FirmWare',
                selectedIcon: Icon(Icons.blur_on_outlined),
              ),
            ];
          } else if (test==3 ) {
            appBarDestinations = [
              NavigationDestination(
                tooltip: '',
                icon: Icon(Icons.bluetooth),
                label: 'Devices',
                selectedIcon: Icon(Icons.bluetooth_outlined),
              ),
              NavigationDestination(
                tooltip: '',
                icon: Icon(Icons.supervised_user_circle),
                label: 'Profile',
                selectedIcon: Icon(Icons.supervised_user_circle_outlined),
              )
            ];
          }

          if (appBarDestinations.length < 2) {
            appBarDestinations.add(NavigationDestination(
              tooltip: '',
              icon: Icon(Icons.error),
              label: 'Error',
              selectedIcon: Icon(Icons.error_outline),
            ));
          }

          // Build the navigation bar
          Widget navigationBar = Focus(
            autofocus: !(widget.isExampleBar || widget.isBadgeExample),
            child: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
                if (!widget.isExampleBar) widget.onSelectItem!(index);
              },
              destinations: widget.isExampleBar && widget.isBadgeExample
                  ? barWithBadgeDestinations
                  : widget.isExampleBar
                      ? exampleBarDestinations
                      : appBarDestinations,
            ),
          );

          if (widget.isExampleBar && widget.isBadgeExample) {
            navigationBar = ComponentDecoration(
              label: 'Badges',
              tooltipMessage: 'Use Badge or Badge.count',
              child: navigationBar,
            );
          } else if (widget.isExampleBar) {
            navigationBar = ComponentDecoration(
              label: 'Navigation bar',
              tooltipMessage: 'Use NavigationBar',
              child: navigationBar,
            );
          }

          return navigationBar;
        } else {
          // While fetching, you can return a loading indicator or something else
          return CircularProgressIndicator(); // Example loading indicator
        }
      },
    );
  }
}

// Rest of your code...


const List<Widget> exampleBarDestinations = [
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.explore_outlined),
    label: 'Explore',
    selectedIcon: Icon(Icons.explore),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.pets_outlined),
    label: 'Pets',
    selectedIcon: Icon(Icons.pets),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.account_box_outlined),
    label: 'Account',
    selectedIcon: Icon(Icons.account_box),
  )
];

List<Widget> barWithBadgeDestinations = [
  NavigationDestination(
    tooltip: '',
    icon: Badge.count(count: 1000, child: Icon(Icons.mail_outlined)),
    label: 'Mail',
    selectedIcon: Badge.count(count: 1000, child: Icon(Icons.mail)),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Badge(label: Text('10'), child: Icon(Icons.chat_bubble_outline)),
    label: 'Chat',
    selectedIcon: Badge(label: Text('10'), child: Icon(Icons.chat_bubble)),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Badge(child: Icon(Icons.group_outlined)),
    label: 'Rooms',
    selectedIcon: Badge(child: Icon(Icons.group_rounded)),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Badge.count(count: 3, child: Icon(Icons.videocam_outlined)),
    label: 'Meet',
    selectedIcon: Badge.count(count: 3, child: Icon(Icons.videocam)),
  ),
];
