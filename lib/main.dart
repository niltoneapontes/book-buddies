import 'package:bookbuddies/pages/ABOUT.dart';
import 'package:bookbuddies/pages/book-details.dart';
import 'package:bookbuddies/pages/book-form.dart';
import 'package:bookbuddies/pages/code.dart';
import 'package:bookbuddies/pages/home.dart';
import 'package:bookbuddies/pages/login.dart';
import 'package:bookbuddies/pages/profile.dart';
import 'package:bookbuddies/pages/settings.dart';
import 'package:bookbuddies/pages/signup.dart';
import 'package:bookbuddies/providers/location_provider.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocationProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const int _primaryColor = 0xFFF45D01;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Book Buddies',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MaterialColor(
            _primaryColor,
            <int, Color>{
              50: Color(0xFFFFF3E0),
              100: Color(0xFFFFE0B2),
              200: Color(0xFFFFCC80),
              300: Color(0xFFFFB74D),
              400: Color(0xEEFFA726),
              500: Color(_primaryColor),
              600: Color(0xFFFB8C00),
              700: Color(0xFFF57C00),
              800: Color(0xFFEF6C00),
              900: Color(0xFFE65100),
            },
          ),
          backgroundColor: Color(0xFFFFFFFF),
          accentColor: Color(0xFF00A6A6),
        ),
        home: LoginPage(),
        routes: {
          AppRoutes.LOGIN: (ctx) => LoginPage(),
          AppRoutes.SIGNUP: (ctx) => SignUpPage(),
          AppRoutes.CODE: (ctx) => VerificationCode(),
          AppRoutes.BOOK_FORM: (ctx) => BookForm(),
          AppRoutes.HOME: (ctx) => HomePage(),
          AppRoutes.BOOK_DETAILS: (ctx) => BookDetails(),
          AppRoutes.PROFILE: (ctx) => Profile(),
          AppRoutes.SETTINGS: (ctx) => Settings(),
          AppRoutes.ABOUT: (ctx) => About(),
        });
  }
}
