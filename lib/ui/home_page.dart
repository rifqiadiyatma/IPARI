import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/ui/about_page.dart';
import 'package:ipari/ui/favorite_page.dart';
import 'package:ipari/ui/main_page.dart';
import 'package:ipari/ui/note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;

  final List<Widget> _listWidget = [
    const MainPage(),
    const FavoritePage(),
    const NotePage(),
    const AboutPage(),
  ];

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
      body: _listWidget[_selectedTab],
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: DotNavigationBar(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 3.0,
              offset: const Offset(
                3.0,
                3.0,
              ),
            ),
          ],
          margin: const EdgeInsets.only(left: 5, right: 5),
          currentIndex: _selectedTab,
          dotIndicatorColor: primaryColor,
          unselectedItemColor: primaryColor,
          items: [
            /// Home
            DotNavigationBarItem(
              icon: _selectedTab == 0
                  ? const Icon(Icons.home)
                  : const Icon(Icons.home_outlined),
              selectedColor: primaryColor,
            ),

            /// Likes
            DotNavigationBarItem(
              icon: _selectedTab == 1
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_outline),
              selectedColor: primaryColor,
            ),

            /// Search
            DotNavigationBarItem(
              icon: _selectedTab == 2
                  ? const Icon(Icons.note)
                  : const Icon(Icons.note_outlined),
              selectedColor: primaryColor,
            ),

            /// Profile
            DotNavigationBarItem(
              icon: _selectedTab == 3
                  ? const Icon(Icons.info)
                  : const Icon(Icons.info_outline),
              selectedColor: primaryColor,
            ),
          ],
          onTap: (int i) {
            setState(() {
              _selectedTab = i;
            });
          },
        ),
      ),
    );
  }
}
