import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:task_nova/providers/user_provider.dart';
import 'package:task_nova/screens/home_screen.dart';
import 'package:task_nova/screens/profile_screen.dart';
import 'package:task_nova/theme/app_theme.dart';
import 'package:task_nova/widgets/custom_text_field.dart';
import 'package:task_nova/widgets/animated_background.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _mockTermsAccepted = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      if (!_mockTermsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept terms and conditions')),
        );
        return;
      }
      setState(() => _isLoading = true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      
      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        // If user name is default ("User"), go to setup. Otherwise go home.
        if (userProvider.userName == "User") {
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen(isSetupMode: true)),
          );
        } else {
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  "Welcome Back!",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign in to continue using TaskNova.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                
                CustomTextField(
                  hintText: "Email Address",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter email';
                    if (!value.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: "Password",
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) {
                    if (value == null || value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                Row(
                  children: [
                    Checkbox(
                      value: _mockTermsAccepted,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (val) {
                        setState(() => _mockTermsAccepted = val ?? false);
                      },
                    ),
                    Expanded(
                      child: Text(
                        "I agree to the Terms of Service & Privacy Policy",
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login", style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}
