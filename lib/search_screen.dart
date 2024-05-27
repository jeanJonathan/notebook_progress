import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Page de recherche',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
