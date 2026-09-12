import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class Step1PersonalInfoWidget extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController nationalIdController;

  const Step1PersonalInfoWidget({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.nationalIdController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 18),
        CustomTextField(
          label: 'Full Name',
          hint: 'Taha Mohamed',
          controller: fullNameController,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          label: 'Email',
          hint: 'teto06920623@business.com',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          label: 'Phone Number',
          hint: '+20 100 000 0000',
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          label: 'National ID',
          hint: '14-digit national ID',
          controller: nationalIdController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
