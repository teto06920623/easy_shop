

import 'dart:io';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final String? initialImageUrl;
  final String? localImagePath;
  final String initials;
  final VoidCallback onPickImage;

  const ProfileAvatarPicker({
    super.key,
    this.initialImageUrl,
    this.localImagePath,
    required this.initials,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2.5),
              color: AppColors.primaryLight,
            ),
            child: ClipOval(child: _buildImageContent()),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onPickImage,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    
    if (localImagePath != null && localImagePath!.isNotEmpty) {
      return Image.file(
        File(localImagePath!),
        width: 96,
        height: 96,
        fit: BoxFit.cover,
      );
    }

    
    if (initialImageUrl != null && initialImageUrl!.isNotEmpty) {
      return Image.network(
        initialImageUrl!,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildInitialsFallback(),
      );
    }

    
    return _buildInitialsFallback();
  }

  Widget _buildInitialsFallback() {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
