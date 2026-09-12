import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AdminRegisterStepIndicator extends StatelessWidget {
  final int currentStep;

  const AdminRegisterStepIndicator({super.key, required this.currentStep});

  String get _stepTitle {
    switch (currentStep) {
      case 1:
        return 'Step 1 of 3 — Personal';
      case 2:
        return 'Step 2 of 3 — Business';
      case 3:
        return 'Step 3 of 3 — Security';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _stepTitle,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(3, (index) {
            final isCompleted = index + 1 <= currentStep;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 2 ? 6 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
