import 'package:flutter/material.dart';

class NotePage extends StatelessWidget {
  static const routeName = '/note_page';
  const NotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Page'),
      ),
    );
  }
}
