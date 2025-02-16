import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie/screens/forget_password.dart';
import 'package:movie/screens/register_screen.dart';
import 'package:movie/utils/app_assets.dart';
import 'package:movie/utils/app_colors.dart';
import 'package:movie/utils/app_styles.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _signInWithEmailAndPassword() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful!')),
      );

      // ✅ التوجيه إلى الصفحة الرئيسية بعد تسجيل الدخول
      Navigator.pushReplacementNamed(context, "/home");

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login Failed')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _auth.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Successful!')),
      );

      // ✅ التوجيه إلى الصفحة الرئيسية بعد تسجيل الدخول
      Navigator.pushReplacementNamed(context, "/home");

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Failed')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.logo, height: 100),
              const SizedBox(height: 32),

              // Email Field
              TextField(
                controller: _emailController,
                style: AppStyles.regular16white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.gray,
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email, color: AppColors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: AppStyles.regular16white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.gray,
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: AppColors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Forget Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ForgetPasswordScreen(),
                    ));
                  },
                  child: Text('Forget Password ?', style: AppStyles.regular14yallow),
                ),
              ),
              const SizedBox(height: 16),

              // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _signInWithEmailAndPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yallow,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: AppColors.white)
                    : Text('Login', style: AppStyles.bold20balck),
              ),
              const SizedBox(height: 16),

              // Signup Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't Have Account ?", style: AppStyles.regular14white),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text('Create One', style: AppStyles.bold20yallow),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // OR Divider
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.gray, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('OR', style: AppStyles.regular14white),
                  ),
                  Expanded(child: Divider(color: AppColors.gray, thickness: 1)),
                ],
              ),
              const SizedBox(height: 16),

              // Google Sign-In Button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yallow,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(Icons.g_translate, color: AppColors.black),
                label: _isLoading
                    ? CircularProgressIndicator(color: AppColors.white)
                    : Text('Login With Google', style: AppStyles.bold20balck),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}