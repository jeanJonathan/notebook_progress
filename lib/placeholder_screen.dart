import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placeholder'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text(
          'Page de placeholder',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
