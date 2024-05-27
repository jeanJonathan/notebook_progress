import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Text(
          'Page de wishlist',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
