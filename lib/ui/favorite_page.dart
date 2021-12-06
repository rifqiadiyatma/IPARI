import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  static const routeName = '/favorite_page';
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Page'),
      ),
    );
  }
}
