import 'package:flutter/material.dart';

Widget customTextButton({
  required BuildContext context,
  required String text,
  required VoidCallback onPressed,
  List<Color> gradientColors = const [Colors.blue, Colors.blueAccent], // Default gradient
  double? width, // Optional width, default is full screen width
}) {
  return SizedBox(
    width: width ?? MediaQuery.of(context).size.width, // Full width by default
    height: 50,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}