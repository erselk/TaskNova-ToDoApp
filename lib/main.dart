import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_nova/providers/task_provider.dart';
import 'package:task_nova/providers/user_provider.dart';
import 'package:task_nova/screens/home_screen.dart';
import 'package:task_nova/screens/onboarding_screen.dart';
import 'package:task_nova/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'TaskNova',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: isLoggedIn ? const HomeScreen() : const OnboardingScreen(),
      ),
    );
  }
}
