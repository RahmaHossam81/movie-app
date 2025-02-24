import 'package:flutter/material.dart';
import 'package:movie/screens/on_boarding.dart';
import 'package:movie/utils/app_assets.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // ✅ تصحيح اسم الدالة
    super.initState(); // ✅ استدعاء super.initState()

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(AppAssets.splashScreen),
            ),
          ),
        ],
      ),
    );
  }
}