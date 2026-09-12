

import 'dart:io';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:easy_shop/core/widgets/custom_text_field.dart';
import 'package:easy_shop/features/categories/domain/entities/category_entity.dart';
import 'package:easy_shop/features/categories/presentation/client/cubit/categories_cubit.dart';
import 'package:easy_shop/features/categories/presentation/client/cubit/categories_state.dart';
import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';
import 'package:easy_shop/features/products/presentation/client/cubit/products_cubit.dart';
import 'package:easy_shop/features/products/presentation/client/cubit/products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddEditProductScreen extends StatefulWidget {
  final bool isEdit;
  final ProductEntity? product;

  const AddEditProductScreen({super.key, this.isEdit = false, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  int? _selectedCategoryId;
  bool _visible = true;
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesCubit>().getCategories(isAdmin: true);
    });

    
    final p = widget.product;
    if (widget.isEdit && p != null) {
      _nameController.text = p.name;
      _descController.text = p.description ?? '';
      _priceController.text = p.price.toString();
      _stockController.text = p.quantity.toString();
      _selectedCategoryId = p.categoryId;
      _visible = p.isVisible;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _onSave() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final quantity = int.tryParse(_stockController.text.trim()) ?? 0;
    final description = _descController.text.trim();

    if (name.isEmpty) {
      _snack('Product name is required');
      return;
    }
    if (price <= 0) {
      _snack('Price must be greater than 0');
      return;
    }
    if (_selectedCategoryId == null) {
      _snack('Please select a category');
      return;
    }

    final cubit = context.read<ProductsCubit>();

    if (widget.isEdit && widget.product != null) {
      cubit.updateProduct(
        slug: widget.product!.slug,
        name: name,
        description: description
            .trim(), 
        price: price,
        quantity: quantity,
        categoryId: _selectedCategoryId!,
        isVisible: _visible,
        imagePath: _imageFile?.path,
      );
    } else {
      cubit.createProduct(
        
        name: name,
        description: description.trim(),
        price: price,
        quantity: quantity,
        categoryId: _selectedCategoryId!,
        isVisible: _visible,
        imagePath: _imageFile?.path,
      );
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        } else if (state is ProductsError) {
          _snack(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is ProductsLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(widget.isEdit ? 'Edit Product' : 'Add New Product'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                GestureDetector(
                  onTap: _pickImage,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            )
                          : (widget.isEdit &&
                                widget.product?.imageUrl != null &&
                                widget.product!.imageUrl!.isNotEmpty)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                widget.product!.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _imagePlaceholder(),
                              ),
                            )
                          : _imagePlaceholder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                
                CustomTextField(
                  label: 'Product Title',
                  hint: 'e.g. MacBook Pro M3',
                  controller: _nameController,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'Price (EGP)',
                  hint: 'e.g. 1200',
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'Stock Quantity',
                  hint: 'e.g. 20',
                  keyboardType: TextInputType.number,
                  controller: _stockController,
                ),
                const SizedBox(height: 14),

                
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                BlocBuilder<CategoriesCubit, CategoriesState>(
                  builder: (context, catState) {
                    if (catState is CategoriesLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: LinearProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    List<CategoryEntity> categories = [];
                    if (catState is CategoriesLoaded) {
                      categories = catState.categories;
                    }

                    
                    final isValidValue = categories.any(
                      (c) => c.id == _selectedCategoryId,
                    );
                    final currentValue = isValidValue
                        ? _selectedCategoryId
                        : null;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          hint: Text(
                            categories.isEmpty
                                ? 'No categories available'
                                : 'Select Category',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                          value: currentValue,
                          items: categories
                              .map(
                                (c) => DropdownMenuItem<int>(
                                  value: c.id,
                                  child: Text(
                                    c.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: categories.isEmpty
                              ? null
                              : (val) =>
                                    setState(() => _selectedCategoryId = val),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),

                CustomTextField(
                  label: 'Description',
                  hint: 'Provide details about the item...',
                  controller: _descController,
                ),
                const SizedBox(height: 14),
                
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                  title: const Text(
                    'Visible to customers',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  value: _visible,
                  onChanged: (val) => setState(() => _visible = val),
                ),

                const SizedBox(height: 24),
                CustomButton(
                  title: widget.isEdit ? 'Save Changes' : 'Publish Product',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _onSave,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imagePlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.primary),
        SizedBox(height: 6),
        Text(
          'Tap to upload product image',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
