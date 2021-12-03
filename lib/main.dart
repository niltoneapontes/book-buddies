import 'package:bookbuddies/pages/home.dart';
import 'package:bookbuddies/pages/login.dart';
import 'package:bookbuddies/pages/signup.dart';
import 'package:bookbuddies/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const int _primaryColor = 0xFFF45D01;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BookBuddies',
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
          AppRoutes.HOME: (ctx) => HomePage(),
        });
  }
}
