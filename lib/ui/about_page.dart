import 'package:flutter/material.dart';
import 'package:ipari/common/styles.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about_page';
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/Logo Background Putih.png'),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'IPARI adalah sebuah aplikasi mobile yang menampilkan data tentang informasi tempat-tempat pariwisata yang ada di Indonesia',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 1.0,
                  color: secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
