import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(), // optional: nicer border
      ),
      obscureText: obscureText,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return "$hintText is missing!";
        }
        return null; // important: return null if valid
      },
    );
  }
}
