

import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/features/categories/data/models/category_model.dart';
import 'package:flutter/material.dart';

class HomeCategoriesSection extends StatelessWidget {
  final List<CategoryModel> categories;
  final int selectedCategoryId;
  final int totalItemsCount;
  final ValueChanged<int> onCategorySelected;

  const HomeCategoriesSection({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.totalItemsCount,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    
    final allCategories = [
      CategoryModel(id: 0, name: 'All', slug: 'all'),
      ...categories,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '$totalItemsCount Items',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: allCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = allCategories[index];
              final isSelected = selectedCategoryId == category.id;

              return GestureDetector(
                onTap: () => onCategorySelected(category.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
