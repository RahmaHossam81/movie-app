import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/screens/main_screen.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:movie/screens/profile_screen.dart';
import 'package:movie/screens/login_screen.dart';
import 'package:movie/utils/app_colors.dart';
import 'package:movie/utils/app_styles.dart';

class UpdateProfile extends StatefulWidget {
  static const String routeName = 'UpdateProfile';

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String avatarSeed = '';
  bool isLoading = true;
  bool showAvatarOptions = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        String email = user.email ?? '';
        String? displayName = user.displayName;
        String? phoneNumber = user.phoneNumber;

        // جلب البيانات من Firestore
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          print("❌ المستخدم ليس لديه بيانات في Firestore!");
          setState(() => isLoading = false);
          return;
        }

        print("✅ بيانات Firestore: ${userDoc.data()}");

        setState(() {
          nameController.text = displayName ?? (userDoc['name'] ?? '');
          phoneController.text = phoneNumber ?? (userDoc['phone'] ?? '');
          avatarSeed = userDoc['avatar'] ?? email;
          isLoading = false;
        });
      } catch (e) {
        print("❌ خطأ أثناء تحميل البيانات: $e");
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _updateUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(nameController.text);
      await _firestore.collection('users').doc(user.uid).update({
        'name': nameController.text,
        'phone': phoneController.text,
        'avatar': avatarSeed,
      });

    //  Navigator.pushReplacementNamed(context, Profile.routeName);
    }
  }

  Future<void> _deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      await _auth.signOut();

      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  void _showAvatarSelection() {
    setState(() {
      showAvatarOptions = !showAvatarOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: AppColors.yallow,
          onPressed: () {
            Navigator.pushNamed(context, Profile.routeName);
          },
        ),
        title: Text("Update Profile", style: AppStyles.regular16yallow),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _showAvatarSelection,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  child: RandomAvatar(avatarSeed, width: 100, height: 100),
                ),
              ),
              SizedBox(height: 20),

              // حقل الاسم
              TextField(
                controller: nameController,
                style: AppStyles.regular20white,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: AppStyles.regular16yallow,
                  filled: true,
                  fillColor: AppColors.gray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  prefixIcon: Icon(Icons.person, color: AppColors.white),
                ),
              ),
              SizedBox(height: 20),

              // حقل رقم الهاتف
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: AppStyles.regular20white,
                decoration: InputDecoration(
                  labelText: "Phone",
                  labelStyle: AppStyles.regular16yallow,
                  filled: true,
                  fillColor: AppColors.gray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  prefixIcon: Icon(Icons.phone, color: AppColors.white),
                ),
              ),
              SizedBox(height: 20),

              // زر Reset Password
              TextButton(
                onPressed: () {
                  _auth.sendPasswordResetEmail(
                      email: _auth.currentUser!.email!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Password reset email sent!")),
                  );
                },
                child: Text("Reset Password", style: AppStyles.regular16yallow),
              ),
              SizedBox(height: 40),

              // زر Update Account
              ElevatedButton(
                onPressed: _updateUserProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yallow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                  child: Text("Update Account", style: AppStyles.regular20black),
                ),
              ),
              SizedBox(height: 20),

              // زر Delete Account
              ElevatedButton(
                onPressed: _deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                  child: Text("Delete Account", style: AppStyles.regular20white),
                ),
              ),
              SizedBox(height: 20),

              // قائمة الأفاتارات
              if (showAvatarOptions)
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      String newSeed = 'avatar_$index';
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            avatarSeed = newSeed;
                            showAvatarOptions = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: avatarSeed == newSeed
                                  ? Colors.yellow
                                  : Colors.transparent,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: RandomAvatar(newSeed,
                                width: 100, height: 100),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}