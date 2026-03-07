import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status; // 'Active' | 'Canceled' | 'Checked In'

  const StatusBadge({super.key, required this.status});

  Color get _bgColor {
    switch (status) {
      case 'Active':
        return const Color(0xFFE8F5E9);
      case 'Checked In':
        return const Color(0xFFE3F2FD);
      case 'Canceled':
        return const Color(0xFFFFEBEE);
      default:
        return Colors.grey.shade100;
    }
  }

  Color get _textColor {
    switch (status) {
      case 'Active':
        return const Color(0xFF2E7D32);
      case 'Checked In':
        return const Color(0xFF1565C0);
      case 'Canceled':
        return const Color(0xFFC62828);
      default:
        return Colors.grey.shade700;
    }
  }

  IconData get _icon {
    switch (status) {
      case 'Active':
        return Icons.check_circle_outline;
      case 'Checked In':
        return Icons.qr_code_scanner;
      case 'Canceled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: _textColor),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: _textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
