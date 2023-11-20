import 'package:flutter/material.dart';

class ExampleDestination {
  const ExampleDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<ExampleDestination> destinations = <ExampleDestination>[
  ExampleDestination('Profile', Icon(Icons.person_4_outlined), Icon(Icons.person_4),),
  ExampleDestination('Aboute', Icon(Icons.notification_important), Icon(Icons.notification_important)),
  ExampleDestination(
      'Favorites', Icon(Icons.favorite_outline), Icon(Icons.favorite)),
  ExampleDestination('Trash', Icon(Icons.delete_outline), Icon(Icons.delete)),
  ExampleDestination('LogOut', Icon(Icons.logout_outlined), Icon(Icons.logout)),
];



