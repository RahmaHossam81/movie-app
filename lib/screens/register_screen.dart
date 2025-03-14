import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie/screens/home_screen.dart';
import 'package:movie/screens/login_screen.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:movie/utils/app_colors.dart';
import 'package:movie/utils/app_styles.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/register";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String selectedAvatarKey = "user0"; // الأفاتار الافتراضي

  Future<void> _registerUser() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // ✅ حفظ بيانات المستخدم في Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'phone': phone,
          'email': email,
          'avatarUrl': "https://api.dicebear.com/7.x/adventurer/svg?seed=$selectedAvatarKey", // توليد الأفاتار بناءً على المفتاح المختار
        });

        print("✅ تم حفظ بيانات المستخدم في Firestore");

        // ✅ الانتقال إلى الصفحة الرئيسية بعد التسجيل
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // زر الرجوع
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.yallow, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 10),

            // عنوان الصفحة
            Text('Register', style: AppStyles.bold20yallow),

            const SizedBox(height: 16),

            // ✅ قائمة أفاتارات قابلة للتمرير الأفقي
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 50,
                itemBuilder: (context, index) {
                  String avatarKey = "user$index";
                  bool isSelected = selectedAvatarKey == avatarKey;

                  return GestureDetector(
                    onTap: () => setState(() => selectedAvatarKey = avatarKey),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.yellow : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: isSelected ? 40 : 30,
                        backgroundColor: Colors.transparent,
                        child: RandomAvatar(avatarKey, height: isSelected ? 70 : 50, width: isSelected ? 70 : 50),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            _buildTextField(_nameController, "Name", Icons.person),
            const SizedBox(height: 16),
            _buildTextField(_emailController, "Email", Icons.email),
            const SizedBox(height: 16),
            _buildPasswordField(_passwordController, "Password", _isPasswordVisible, (value) {
              setState(() => _isPasswordVisible = value);
            }),
            const SizedBox(height: 16),
            _buildPasswordField(_confirmPasswordController, "Confirm Password", _isConfirmPasswordVisible, (value) {
              setState(() => _isConfirmPasswordVisible = value);
            }),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, "Phone Number", Icons.phone),

            const SizedBox(height: 20),

            // زر إنشاء الحساب
            ElevatedButton(
              onPressed: _registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yallow,
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Create Account', style: AppStyles.bold20balck),
            ),

            const SizedBox(height: 20),

            // الانتقال إلى تسجيل الدخول
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already Have Account?", style: AppStyles.regular14white),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  child: Text('Login', style: AppStyles.bold20yallow),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      style: AppStyles.regular16white,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.gray,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint, bool isVisible, Function(bool) onToggle) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      style: AppStyles.regular16white,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.gray,
        hintText: hint,
        prefixIcon: Icon(Icons.lock, color: AppColors.white),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.white,
          ),
          onPressed: () => onToggle(!isVisible),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}