import 'package:flutter/material.dart';

class MyButtonScreen extends StatelessWidget {
  const MyButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Add the button's action here
          },
          child: Text('Click Me'),
        ),
      ),
    );
  }
}
