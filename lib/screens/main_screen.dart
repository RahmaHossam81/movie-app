import 'package:flutter/material.dart';
import 'package:movie/screens/home_screen.dart';
import 'package:movie/screens/movie_by_genre_screen.dart';
import 'package:movie/screens/profile_screen.dart';
import 'package:movie/screens/search_screen.dart';
import 'package:movie/utils/app_colors.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // المؤشر الحالي للصفحة

  final List<Widget> _screens = [
    HomeScreen(), // الصفحة الرئيسية
    SearchScreen(), // صفحة المفضلة
    MoviesByGenreScreen(), // الملف الشخصي
    Profile(), // الإعدادات
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // تحديث الصفحة الحالية
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: IndexedStack(
        index: _selectedIndex, // يحافظ على حالة كل صفحة بدل ما يعيد تحميلها
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.yallow,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // يحافظ على الأيقونات حتى لو أكثر من 3
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "/home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "/search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "/browse"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Profile"),
        ],
      ),
    );
  }
}