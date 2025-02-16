import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie/screens/forget_password.dart';
import 'package:movie/screens/home_screen.dart'; // ✅ إضافة الصفحة الرئيسية
import 'package:movie/screens/login_screen.dart';
import 'package:movie/screens/register_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark(),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        ForgetPasswordScreen.routeName: (context) => ForgetPasswordScreen(),
       HomeScreen.routeName: (context) => HomeScreen(),// ✅ إضافة الصفحة الرئيسية
      },
    );
  }
}