import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status; // 'Active' | 'Canceled' | 'Checked In'

  const StatusBadge({super.key, required this.status});

  Color get _bgColor {
    switch (status) {
      case 'Active':
        return const Color(0xFFDCFCE7);
      case 'Checked In':
        return const Color(0xFFDBEAFE);
      case 'Canceled':
        return const Color(0xFFFEE2E2);
      default:
        return Colors.grey.shade100;
    }
  }

  Color get _textColor {
    switch (status) {
      case 'Active':
        return const Color(0xFF16A34A);
      case 'Checked In':
        return const Color(0xFF2563EB);
      case 'Canceled':
        return const Color(0xFFDC2626);
      default:
        return Colors.grey.shade700;
    }
  }

  IconData get _icon {
    switch (status) {
      case 'Active':
        return Icons.check_circle;
      case 'Checked In':
        return Icons.qr_code;
      case 'Canceled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: _textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: _textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
