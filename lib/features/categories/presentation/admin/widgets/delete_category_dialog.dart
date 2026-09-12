import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final String categoryName;

  const DeleteCategoryDialog({super.key, required this.categoryName});

  static Future<bool?> show(BuildContext context, String categoryName) {
    return showDialog<bool>(
      context: context,
      builder: (_) => DeleteCategoryDialog(categoryName: categoryName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Category'),
      content: Text('Are you sure you want to delete "$categoryName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete', style: TextStyle(color: AppColors.error)),
        ),
      ],
    );
  }
}
