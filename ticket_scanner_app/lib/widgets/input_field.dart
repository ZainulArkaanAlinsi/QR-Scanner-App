import 'package:flutter/material.dart';
import '../core/utils/helper.dart';

/// Shared reusable input field used by LoginScreen and RegisterScreen
class AppInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData icon;
  final Widget? suffix;

  const AppInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      onTapOutside: Helper.onTapOutside,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1A237E), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
