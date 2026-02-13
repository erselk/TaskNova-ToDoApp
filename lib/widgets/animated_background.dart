import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:task_nova/theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppTheme.backgroundColor),
        
        // Animated Blob 1 (Top Right)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              top: -100 + (_controller.value * 20),
              right: -100 + (_controller.value * 20),
              child: child!,
            );
          },
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.1),
                  AppTheme.primaryColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        
        // Animated Blob 2 (Center Left)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.3 + (_controller.value * -30),
              left: -100 + (_controller.value * 20),
              child: child!,
            );
          },
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.secondaryColor.withOpacity(0.1),
                  AppTheme.secondaryColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),

         // Animated Blob 3 (Bottom Right)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              bottom: -50 + (_controller.value * -20),
              right: -50 + (_controller.value * 30),
              child: child!,
            );
          },
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.purple.withOpacity(0.08),
                  Colors.purple.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),

        // Content
        widget.child,
      ],
    );
  }
}
