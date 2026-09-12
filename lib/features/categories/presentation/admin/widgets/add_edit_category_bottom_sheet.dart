import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:easy_shop/core/widgets/custom_text_field.dart';
import 'package:easy_shop/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

class AddEditCategoryBottomSheet extends StatefulWidget {
  final CategoryEntity? existingCategory;
  final Function(String name, String? description) onSave;

  const AddEditCategoryBottomSheet({
    super.key,
    this.existingCategory,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    CategoryEntity? existingCategory,
    required Function(String name, String? description) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddEditCategoryBottomSheet(
        existingCategory: existingCategory,
        onSave: onSave,
      ),
    );
  }

  @override
  State<AddEditCategoryBottomSheet> createState() =>
      _AddEditCategoryBottomSheetState();
}

class _AddEditCategoryBottomSheetState
    extends State<AddEditCategoryBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingCategory?.name ?? '',
    );
    _descController = TextEditingController(
      text: widget.existingCategory?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category name is required'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final description = _descController.text.trim();
    widget.onSave(name, description.isEmpty ? null : description);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingCategory != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEdit ? 'Edit Category' : 'Add New Category',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Category Name',
            hint: 'e.g. Smart Watches',
            controller: _nameController,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            label: 'Description (Optional)',
            hint: 'Short description',
            controller: _descController,
          ),
          const SizedBox(height: 20),
          CustomButton(
            title: isEdit ? 'Save Changes' : 'Create Category',
            onPressed: _handleSubmit,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
