

import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AdminProductOverviewCard extends StatelessWidget {
  final String title;
  final String priceQty;
  final bool isVisible;
  final String? imageUrl;
  final IconData icon;

  const AdminProductOverviewCard({
    super.key,
    required this.title,
    required this.priceQty,
    this.isVisible = true,
    this.imageUrl,
    this.icon = Icons.shopping_bag_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: (imageUrl != null && imageUrl!.trim().isNotEmpty)
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(icon, color: AppColors.primary, size: 24),
                    )
                  : Icon(icon, color: AppColors.primary, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  priceQty,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isVisible ? Colors.green.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isVisible ? '• Visible' : '• Hidden',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isVisible ? Colors.green : AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
