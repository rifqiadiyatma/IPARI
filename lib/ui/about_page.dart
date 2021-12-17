import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about_page';
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 75,
          width: 150,
          child: Image.asset('assets/Logo Font.png'),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: Center(
        child: Text('INI PAGE ABOUT'),
      ),
    );
  }
}
