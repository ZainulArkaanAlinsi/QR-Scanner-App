import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const ErrorCard({super.key, required this.message, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        border: Border.all(color: const Color(0xFFFF5C5C)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFD32F2F), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFD32F2F),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Color(0xFFD32F2F)),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
