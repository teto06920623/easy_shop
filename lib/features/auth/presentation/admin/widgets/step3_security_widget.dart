import 'dart:io';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class Step3SecurityWidget extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? uploadedPicturePath;
  final VoidCallback onUploadPicture;
  final VoidCallback onRemovePicture;

  const Step3SecurityWidget({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    this.uploadedPicturePath,
    required this.onUploadPicture,
    required this.onRemovePicture,
  });

  @override
  State<Step3SecurityWidget> createState() => _Step3SecurityWidgetState();
}

class _Step3SecurityWidgetState extends State<Step3SecurityWidget> {
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;

  @override
  Widget build(BuildContext context) {
    final hasPicture = widget.uploadedPicturePath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Security & Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Profile Picture (Optional)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: hasPicture ? null : widget.onUploadPicture,
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasPicture ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasPicture) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(widget.uploadedPicturePath!),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.uploadedPicturePath!.split(Platform.pathSeparator).last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: widget.onRemovePicture,
                  ),
                ] else ...[
                  const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.textMuted,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Upload profile photo',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Password',
          hint: 'Create a strong password',
          controller: widget.passwordController,
          isPassword: _obscurePass,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePass
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textMuted,
              size: 20,
            ),
            onPressed: () => setState(() => _obscurePass = !_obscurePass),
          ),
        ),
        const SizedBox(height: 14),
        CustomTextField(
          label: 'Confirm Password',
          hint: 'Repeat your password',
          controller: widget.confirmPasswordController,
          isPassword: _obscureConfirmPass,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPass
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textMuted,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscureConfirmPass = !_obscureConfirmPass),
          ),
        ),
      ],
    );
  }
}