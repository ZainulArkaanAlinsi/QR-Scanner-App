import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const ErrorCard({super.key, required this.message, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.2), width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.info_outline, color: theme.colorScheme.error, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error Occurred',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 12),
            IconButton(
              onPressed: onDismiss,
              icon: Icon(Icons.close, size: 18, color: theme.colorScheme.error.withValues(alpha: 0.5)),
            ),
          ],
        ],
      ),
    );
  }
}
