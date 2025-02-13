import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF4996B4);
  static const Color primaryGreen = Color(0xFFACD192);
  static const Color withdrawal = Color(0xFFF03B33);
  static const Color background = Color(0xFFF2F2F2);
  static const Color text = Color(0xFFABABAB);
}

class UIHelpers {
  static void showSnackbar(BuildContext context, String message, {Color color = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
