import 'package:flutter/material.dart';
import 'package:ipari/data/api/api_service.dart';
import 'package:ipari/data/model/wisata.dart';
import 'package:ipari/provider/wisata_provider.dart';
import 'package:ipari/ui/about_page.dart';
import 'package:ipari/ui/detail_page.dart';
import 'package:ipari/ui/favorite_page.dart';
import 'package:ipari/ui/main_page.dart';
import 'package:ipari/ui/note_page.dart';
import 'package:ipari/ui/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WisataProvider(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => SplashScreen(),
          MainPage.routeName: (context) => const MainPage(),
          FavoritePage.routeName: (context) => const FavoritePage(),
          AboutPage.routeName: (context) => const AboutPage(),
          NotePage.routeName: (context) => const NotePage(),
          DetailPage.routeName: (context) => DetailPage(
                wisata: ModalRoute.of(context)?.settings.arguments as Wisata,
              ),
        },
      ),
    );
  }
}
