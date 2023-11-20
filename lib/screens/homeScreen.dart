import 'package:ota/constant.dart';
import 'package:ota/screens/Ble/screens/scan_screen.dart';
import 'package:ota/screens/admin/device/Admin_Device.dart';
import 'package:ota/screens/admin/firmware/Admin_Fire.dart';



import 'package:ota/screens/components/NavigationBar/NavigationBar_Screen.dart';
import 'package:ota/screens/components/NavigationBar/constant.dart';
import 'package:ota/screens/components/NavigationTransition.dart';
import 'package:ota/screens/super_admin/device/device_screen.dart';
import 'package:ota/screens/super_admin/firmware/firm_screen.dart';
import 'package:ota/screens/super_admin/user/users_screen.dart';
import 'package:ota/screens/test.dart';
import 'package:ota/screens/user/bluetooth_off_screen.dart';
import 'package:ota/screens/user/profile_screen.dart';




import 'package:ota/services/DbService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class Home extends StatefulWidget {




  const Home({
    super.key,
    required this.useLightMode,
    required this.useMaterial3,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleMaterialVersionChange,
    required this.handleColorSelect,
    required this.handleImageSelect,
    required this.colorSelectionMethod,
    required this.imageSelected,
  });

  final bool useLightMode;
  final bool useMaterial3;
  final ColorSeed colorSelected;
  final ColorImageProvider imageSelected;
  final ColorSelectionMethod colorSelectionMethod;

  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function() handleMaterialVersionChange;
  final void Function(int value) handleColorSelect;
  final void Function(int value) handleImageSelect;

  @override
  State<Home> createState() => _HomeState();
}

DbService dbService = DbService();

Future<String> isAdmin() async {
  String admin = await dbService
      .checkAdminStatus();// Assuming '1' means admin and '2' means non-admin
  return admin;
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  bool controllerInitialized = false;
  bool showMediumSizeLayout = false;
  bool showLargeSizeLayout = false;

  int screenIndex = ScreenSelected.component.value;
 late Future<String> admin ; // Default admin status, nullable
 // Default admin status

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: transitionLength.toInt() * 2),
      value: 0,
      vsync: this,
    );
    railAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0),
    );

admin = isAdmin();
  }



  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleScreenChanged(int screenSelected) {
    setState(() {
      screenIndex = screenSelected;
    });
  }

Widget createScreenFor(
    ScreenSelected screenSelected,
    bool showNavBarExample,
    String admin,
  ) {
    int valueadmin = int.parse(admin );

    if (valueadmin == 1) {
      switch (screenSelected) {
        case ScreenSelected.users:
          return const UserScreen();
        case ScreenSelected.component:
          return const DeviceScreen();
        case ScreenSelected.typography:
          return const FirmScreen();
      }
    } else if (valueadmin == 2) {
      switch (screenSelected) {
        case ScreenSelected.users:
          return const AdminDeviceScreen();
        case ScreenSelected.component:
          return const AdminFirmScreen();
        case ScreenSelected.typography:
          return const MyButtonScreen();
      }
    } else if (valueadmin == 3) {
      switch (screenSelected) {
        case ScreenSelected.component:
          return const Expanded(child: ProfileScreen()) ;
        case ScreenSelected.users:
          return Expanded(
            child: StreamBuilder<BluetoothAdapterState>(
              stream: FlutterBluePlus.adapterState,
              initialData: BluetoothAdapterState.unknown,
              builder: (c, snapshot) {
                final adapterState = snapshot.data;
                if (adapterState == BluetoothAdapterState.on) {
                  return const ScanScreen();
                } else {
                  FlutterBluePlus.stopScan();
                  return BluetoothOffScreen(adapterState: adapterState);
                }
              },
            ),
          );
        case ScreenSelected.typography:
          return const Expanded(
            child:  ProfileScreen(),
          );
      }
    } else {
      return const MyButtonScreen();
    }
  }

  PreferredSizeWidget createAppBar() {
    return AppBar(
      title: Image.asset(
        'assets/logoOTA.png',
        width: 60,
        height: 55,
      ),
    );
  }

    @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: admin,
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator()
          ); // Loading indicator
        } else if (snapshot.hasError || snapshot.data == null) {
          return Text('Error loading admin data'); // Error message or handling
        }
        final adminValue = snapshot.data!;
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return NavigationTransition(
              scaffoldKey: scaffoldKey,
              animationController: controller,
              railAnimation: railAnimation,
              appBar: createAppBar(),
              body: createScreenFor(
                ScreenSelected.values[screenIndex],
                controller.value == 1,
                adminValue,
              ),
              navigationRail: NavigationRail(
                extended: showMediumSizeLayout,
                destinations: navRailDestinations,
                selectedIndex: screenIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    screenIndex = index;
                    handleScreenChanged(screenIndex);
                  });
                },
                trailing: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(''),
                  ),
                ),
              ),
              navigationBar: NavigationBars(
                onSelectItem: (index) {
                  setState(() {
                    screenIndex = index;
                    handleScreenChanged(screenIndex);
                  });
                },
                selectedIndex: screenIndex,
                isExampleBar: false,
              ),
            );
          },
        );
      },
    );
  }
}



final List<NavigationRailDestination> navRailDestinations = appBarDestinations
    .map(
      (destination) => NavigationRailDestination(
        icon: Tooltip(
          message: destination.label,
          child: destination.icon,
        ),
        selectedIcon: Tooltip(
          message: destination.label,
          child: destination.selectedIcon,
        ),
        label: Text(destination.label),
      ),
    )
    .toList();


class _ExpandedTrailingActions extends StatelessWidget {
  const _ExpandedTrailingActions({
    required this.useLightMode,
    required this.handleBrightnessChange,
    required this.useMaterial3,
    required this.handleMaterialVersionChange,
    required this.handleColorSelect,
    required this.handleImageSelect,
    required this.imageSelected,
    required this.colorSelected,
    required this.colorSelectionMethod,
  });

  final void Function(bool) handleBrightnessChange;
  final void Function() handleMaterialVersionChange;
  final void Function(int) handleImageSelect;
  final void Function(int) handleColorSelect;

  final bool useLightMode;
  final bool useMaterial3;

  final ColorImageProvider imageSelected;
  final ColorSeed colorSelected;
  final ColorSelectionMethod colorSelectionMethod;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final trailingActionsBody = Container(
      constraints: const BoxConstraints.tightFor(width: 250),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [],
      ),
    );
    return screenHeight > 740
        ? trailingActionsBody
        : SingleChildScrollView(child: trailingActionsBody);
  }
}
