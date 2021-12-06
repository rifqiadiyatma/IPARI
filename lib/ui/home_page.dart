import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:ipari/common/styles.dart';
import 'package:ipari/ui/about_page.dart';
import 'package:ipari/ui/favorite_page.dart';
import 'package:ipari/ui/main_page.dart';
import 'package:ipari/ui/note_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;

  // void _handleIndexChanged(int i) {
  //   setState(() {
  //     _selectedTab = values[i];
  //   });
  // }

  final List<Widget> _listWidget = [
    const MainPage(),
    const FavoritePage(),
    const NotePage(),
    const AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_selectedTab],
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: DotNavigationBar(
          margin: EdgeInsets.only(left: 10, right: 10),
          currentIndex: _selectedTab,
          dotIndicatorColor: primaryColor,
          unselectedItemColor: Colors.grey[300],
          // enableFloatingNavBar: false,
          items: [
            /// Home
            DotNavigationBarItem(
              icon: Icon(Icons.home),
              selectedColor: primaryColor,
            ),

            /// Likes
            DotNavigationBarItem(
              icon: Icon(Icons.favorite),
              selectedColor: primaryColor,
            ),

            /// Search
            DotNavigationBarItem(
              icon: Icon(Icons.note),
              selectedColor: primaryColor,
            ),

            /// Profile
            DotNavigationBarItem(
              icon: Icon(Icons.person),
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
