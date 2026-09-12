import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AdminProductMetricsCard extends StatelessWidget {
  final String price;
  final String inStock;
  final bool isVisible;

  const AdminProductMetricsCard({
    super.key,
    required this.price,
    required this.inStock,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMetricItem(
              value: price,
              label: 'Price',
              valueColor: AppColors.primary,
            ),
          ),
          Container(height: 30, width: 1, color: AppColors.border),
          Expanded(
            child: _buildMetricItem(
              value: inStock,
              label: 'In Stock',
              valueColor: AppColors.textDark,
            ),
          ),
          Container(height: 30, width: 1, color: AppColors.border),
          Expanded(
            child: _buildMetricItem(
              value: isVisible ? '• Visible' : '• Hidden',
              label: 'Visibility',
              valueColor: isVisible ? Colors.green : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}