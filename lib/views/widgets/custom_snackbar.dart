import 'package:flutter/material.dart';
import 'package:sevanta_delivery_partner/utils/constants/enums.dart';

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    String? title,
    SnackBarType type = SnackBarType.success,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final Color color = _getColor(type);
    final IconData icon = _getIcon(type);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: duration,
          padding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null) ...[
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onAction != null && actionLabel != null)
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      onAction();
                    },
                    child: Text(
                      actionLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
  }

  static Color _getColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Colors.green.shade700;
      case SnackBarType.error:
        return Colors.red.shade700;
    }
  }

  static IconData _getIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.error:
        return Icons.error_outline;
    }
  }
}
