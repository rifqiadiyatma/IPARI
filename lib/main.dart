import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ipari/data/api/api_service.dart';
import 'package:ipari/data/db/database_helper.dart';
import 'package:ipari/data/model/model_review.dart';
import 'package:ipari/data/model/wisata.dart';
import 'package:ipari/provider/database_provider.dart';
import 'package:ipari/provider/wisata_provider.dart';
import 'package:ipari/ui/change_password_page.dart';
import 'package:ipari/ui/profile_page.dart';
import 'package:ipari/ui/add_review_page.dart';
import 'package:ipari/ui/detail_page.dart';
import 'package:ipari/ui/detail_review.dart';
import 'package:ipari/ui/favorite_page.dart';
import 'package:ipari/ui/login_page.dart';
import 'package:ipari/ui/main_page.dart';
import 'package:ipari/ui/about_page.dart';
import 'package:ipari/ui/register_page.dart';
import 'package:ipari/ui/review_page.dart';
import 'package:ipari/ui/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: MaterialApp(
        home: const SplashScreen(),
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          MainPage.routeName: (context) => const MainPage(),
          LoginPage.routeName: (context) => const LoginPage(),
          RegisterPage.routeName: (context) => const RegisterPage(),
          ReviewPage.routeName: (context) => const ReviewPage(),
          FavoritePage.routeName: (context) => const FavoritePage(),
          ProfilePage.routeName: (context) => const ProfilePage(),
          AboutPage.routeName: (context) => const AboutPage(),
          ChangePasswordPage.routeName: (context) => const ChangePasswordPage(),
          DetailReview.routeName: (context) => DetailReview(
                review:
                    ModalRoute.of(context)?.settings.arguments as ModelReview,
              ),
          AddReviewPage.routeName: (context) => const AddReviewPage(),
          DetailPage.routeName: (context) => DetailPage(
                wisata: ModalRoute.of(context)?.settings.arguments as Wisata,
              ),
        },
      ),
    );
  }
}
