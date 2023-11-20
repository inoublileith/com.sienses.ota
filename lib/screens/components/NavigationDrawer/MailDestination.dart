import 'package:flutter/material.dart';

class ExampleDestination {
  const ExampleDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<ExampleDestination> destinations = <ExampleDestination>[
<<<<<<< HEAD
  ExampleDestination('Profile', Icon(Icons.person_4_outlined), Icon(Icons.person_4),),
  ExampleDestination('Aboute', Icon(Icons.notification_important), Icon(Icons.notification_important)),
=======
  ExampleDestination('Inbox', Icon(Icons.inbox_outlined), Icon(Icons.inbox),),
  ExampleDestination('Outbox', Icon(Icons.send_outlined), Icon(Icons.send)),
>>>>>>> origin/main
  ExampleDestination(
      'Favorites', Icon(Icons.favorite_outline), Icon(Icons.favorite)),
  ExampleDestination('Trash', Icon(Icons.delete_outline), Icon(Icons.delete)),
  ExampleDestination('LogOut', Icon(Icons.logout_outlined), Icon(Icons.logout)),
];

<<<<<<< HEAD


=======
const List<ExampleDestination> labelDestinations = <ExampleDestination>[
  ExampleDestination(
      'Family', Icon(Icons.bookmark_border), Icon(Icons.bookmark)),
  ExampleDestination(
      'School', Icon(Icons.bookmark_border), Icon(Icons.bookmark)),
  ExampleDestination('Work', Icon(Icons.bookmark_border), Icon(Icons.bookmark)),
];
>>>>>>> origin/main
