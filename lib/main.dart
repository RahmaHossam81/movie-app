import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/movie_details.dart';
import 'package:movie/screens/forget_password.dart';
import 'package:movie/screens/home_screen.dart';
import 'package:movie/screens/login_screen.dart';
import 'package:movie/screens/movie_details.dart';
import 'package:movie/screens/on_boarding.dart';
import 'package:movie/screens/register_screen.dart';
import 'package:movie/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());

 // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark(),
      initialRoute: HomeScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        ForgetPasswordScreen.routeName: (context) => ForgetPasswordScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == MovieDetailsScreen.routeName) {
          final int movieId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movieId: movieId),
          );
        }
        return null;
      },
    );
  }
}