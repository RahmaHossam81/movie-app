import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie/utils/app_colors.dart';
import 'package:movie/utils/app_styles.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String routeName = "/forget-password";

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // دالة لإرسال طلب إعادة تعيين كلمة المرور
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage("Please enter your email", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showMessage("Password reset link sent! Check your email.", Colors.green);
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "An error occurred", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // دالة لعرض الرسائل المنبثقة
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان مع زر الرجوع
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.yallow, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 60),
                  Text('Forget Password', style: AppStyles.bold20yallow),
                ],
              ),
              const SizedBox(height: 20),

              // صورة التوضيح
              Center(
                child: Image.asset(
                  'assets/images/forget_password.png', // تأكد من وجود الصورة في المسار الصحيح
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),

              const SizedBox(height: 20),

              // حقل إدخال البريد الإلكتروني
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppStyles.regular16white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.gray,
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email, color: AppColors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // زر التحقق
              ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yallow,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: AppColors.black)
                    : Text('Verify Email', style: AppStyles.bold20balck),
              ),
            ],
          ),
        ),
      ),
    );
  }
}