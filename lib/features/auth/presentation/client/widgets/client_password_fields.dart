import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ClientPasswordFields extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const ClientPasswordFields({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<ClientPasswordFields> createState() => _ClientPasswordFieldsState();
}

class _ClientPasswordFieldsState extends State<ClientPasswordFields> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Password *',
          hint: '••••••••',
          controller: widget.passwordController,
          isPassword: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textMuted,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 14),
        CustomTextField(
          label: 'Confirm Password *',
          hint: '••••••••',
          controller: widget.confirmPasswordController,
          isPassword: _obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textMuted,
              size: 20,
            ),
            onPressed: () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword,
            ),
          ),
        ),
      ],
    );
  }
}
