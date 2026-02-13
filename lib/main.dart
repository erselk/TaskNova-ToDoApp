import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_nova/providers/task_provider.dart';
import 'package:task_nova/providers/user_provider.dart';
import 'package:task_nova/screens/home_screen.dart';

// ... (omitting lines for brevity)

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
