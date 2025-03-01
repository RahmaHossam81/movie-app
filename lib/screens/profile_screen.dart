import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/screens/login_screen.dart';
import 'package:movie/screens/update_profile_screen.dart';
import 'package:movie/utils/app_colors.dart';
import 'package:movie/utils/app_styles.dart';
import 'package:movie/utils/app_assets.dart'; // إضافة ملف الصور الافتراضية

class Profile extends StatefulWidget {
  static const String routeName = 'Profile';
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String username = "Guest";
  int wishListCount = 0;
  int historyCount = 0;
  List<dynamic> wishList = [];
  List<dynamic> history = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchUserData();
    fetchWishList();
    fetchHistory();
  }

  void fetchUserData() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc('user_id').get();
    if (userDoc.exists) {
      setState(() {
        username = userDoc.data()?['name'] ?? "Guest";
      });
    }
  }

  void fetchWishList() async {
    FirebaseFirestore.instance.collection('watchlist').snapshots().listen((snapshot) {
      setState(() {
        wishList = snapshot.docs.map((doc) => doc.data()).toList();
        wishListCount = wishList.length; // ✅ تحديث عدد الأفلام عند التغيير
      });
    });
  }

  void fetchHistory() async {
    FirebaseFirestore.instance.collection('history').snapshots().listen((snapshot) {
      setState(() {
        history = snapshot.docs.map((doc) => doc.data()).toList();
        historyCount = history.length;
      });
    });
  }

  /// دالة لفحص الروابط قبل تحميل الصورة
  Widget loadImage(String? imageUrl, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (imageUrl == null || imageUrl.isEmpty || !imageUrl.startsWith("http")) {
      return Image.asset(AppAssets.Empty, width: width, height: height, fit: fit);
    }
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(AppAssets.Empty, width: width, height: height, fit: fit);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(color: AppColors.gray),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            const CircleAvatar(radius: 40),
                            const SizedBox(height: 16),
                            Text(username, style: AppStyles.bold24white),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(wishListCount.toString(), style: AppStyles.bold24white),
                            const SizedBox(height: 16),
                            Text("Wish List", style: AppStyles.bold24white),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Text(historyCount.toString(), style: AppStyles.bold24white),
                            const SizedBox(height: 16),
                            Text("History", style: AppStyles.bold24white),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, UpdateProfile.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(190, 50),
                            backgroundColor: AppColors.yallow,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text("Edit Profile", style: AppStyles.regular20black),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () async {
                            // تسجيل خروج المستخدم من FirebaseAuth (إذا كنت تستخدمه)
                            await FirebaseAuth.instance.signOut();

                            // الانتقال إلى شاشة تسجيل الدخول وإزالة جميع الشاشات السابقة من الـ stack
                            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(130, 50),
                            backgroundColor: AppColors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Exit", style: AppStyles.regular20white),
                              const SizedBox(width: 8),
                              const Icon(Icons.exit_to_app, color: Colors.white, size: 28),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 75,
              color: AppColors.gray,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.yallow,
                tabs: const [
                  Tab(icon: Icon(Icons.view_list_rounded, size: 30), text: "Watch List"),
                  Tab(icon: Icon(Icons.history, size: 30), text: "History"),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: AppColors.black,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    wishList.isEmpty
                        ? const Center(child: Text('No movies in Wish List', style: TextStyle(color: Colors.white)))
                       :Padding(
                         padding: const EdgeInsets.only(top: 24,left: 10),
                         child: SingleChildScrollView(
                           child: GridView.builder(
                                                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 3 أفلام في كل صف
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65, // للحفاظ على تناسق الأبعاد
                                                 ),
                                                 shrinkWrap: true,
                                                 physics: const NeverScrollableScrollPhysics(),
                                                 itemCount: wishList.length,
                                                 itemBuilder: (context, index) {
                            final movie = wishList[index];

                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                // بوستر الفيلم
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    movie['poster'] ?? '',
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // تقييم الفيلم (يظهر أعلى البوستر)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star, color: Colors.yellow, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          movie['rating']?.toString() ?? 'N/A', // يعرض التقييم الصحيح
                                          style: AppStyles.regular16white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                                                 },
                                               ),
                         ),
                       ),
                    history.isEmpty
                        ? const Center(child: Text('No history found', style: TextStyle(color: Colors.white)))
                        :Padding(
                          padding: const EdgeInsets.only(top: 24,left: 10),
                          child: SingleChildScrollView(
                            child: GridView.builder(
                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 3 أفلام في كل صف
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65, // للحفاظ على تناسق الأبعاد
                                                  ),
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: history.length,
                                                  itemBuilder: (context, index) {
                            final movie = history[index];

                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                // بوستر الفيلم
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    movie['poster'] ?? '',
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // تقييم الفيلم (يظهر أعلى البوستر)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star, color: Colors.yellow, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          movie['rating']?.toString() ?? 'N/A', // يعرض التقييم الصحيح
                                          style: AppStyles.regular16white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                                                  },
                                                ),
                          ),
                        )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}