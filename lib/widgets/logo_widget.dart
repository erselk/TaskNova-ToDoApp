import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final bool animated;
  final Color? color;

  const LogoWidget({
    super.key,
    this.size = 100,
    this.animated = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/tasknova.png',
        fit: BoxFit.contain,
        color: color, // Optional: apply color filter if needed, though usually not for full color logos
        colorBlendMode: color != null ? BlendMode.srcIn : null,
      ),
    );
  }
}
