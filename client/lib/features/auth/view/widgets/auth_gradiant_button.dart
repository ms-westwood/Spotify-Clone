import 'package:client/core/team/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;

  const AuthGradientButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Use the container tap instead of ElevatedButton
      child: Container(
        width: 295,
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Pallete.gradient1, Pallete.gradient2],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white, // Make sure text is visible on gradient
          ),
        ),
      ),
    );
  }
}
