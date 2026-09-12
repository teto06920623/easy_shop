import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OtpTimerResendSection extends StatelessWidget {
  final String formattedTime;
  final VoidCallback onResend;

  const OtpTimerResendSection({
    super.key,
    required this.formattedTime,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(
              'Code expires in $formattedTime',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: onResend,
          icon: const Icon(Icons.refresh, size: 16, color: AppColors.primary),
          label: const Text(
            'Resend Code',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
