import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/ui/home_page.dart';
import 'package:ipari/ui/main_page.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash_screen';

  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primaryColor,
        child: Center(
          child: SizedBox(
              height: 200,
              width: 200,
              child: Image.asset('assets/Logo Background Putih.png')),
        ),
      ),
    );
  }
}
