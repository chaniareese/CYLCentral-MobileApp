import 'package:flutter/material.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Events')),
      body: const Center(
        child: Text('Your registered events, e-cert, and ID will appear here.'),
      ),
    );
  }
}
