

import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/empty_state_view.dart';
import 'package:easy_shop/core/widgets/error_view.dart';
import 'package:easy_shop/core/widgets/loading_indicator.dart';
import 'package:easy_shop/features/categories/domain/entities/category_entity.dart';
import 'package:easy_shop/features/categories/presentation/client/cubit/categories_cubit.dart';
import 'package:easy_shop/features/categories/presentation/client/cubit/categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/add_edit_category_bottom_sheet.dart';
import '../widgets/category_item_tile.dart';
import '../widgets/delete_category_dialog.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesCubit>().getCategories(isAdmin: true);
    });
  }

  Future<void> _handleDelete(CategoryEntity category) async {
    final confirmed = await DeleteCategoryDialog.show(context, category.name);
    if (confirmed == true && mounted) {
      context.read<CategoriesCubit>().deleteCategory(category.slug);
    }
  }

  void _openAddEditSheet({CategoryEntity? existing}) {
    AddEditCategoryBottomSheet.show(
      context,
      existingCategory: existing,
      onSave: (name, description) {
        if (existing != null) {
          context.read<CategoriesCubit>().updateCategory(
            slug: existing.slug,
            name: name,
            description: description,
          );
        } else {
          context.read<CategoriesCubit>().createCategory(
            name: name,
            description: description,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Categories'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
              size: 28,
            ),
            onPressed: () => _openAddEditSheet(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<CategoriesCubit, CategoriesState>(
        listener: (context, state) {
          if (state is CategoryActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 1),
              ),
            );
          } else if (state is CategoriesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return const LoadingIndicator();
          }

          if (state is CategoriesError) {
            return ErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<CategoriesCubit>().getCategories(isAdmin: true),
            );
          }

          if (state is CategoriesLoaded) {
            if (state.categories.isEmpty) {
              return EmptyStateView(
                title: 'No categories yet',
                description:
                    'Start organizing your store by adding your first category.',
                icon: Icons.category_outlined,
                buttonText: 'Add Category',
                onAction: () => _openAddEditSheet(),
              );
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () =>
                  context.read<CategoriesCubit>().getCategories(isAdmin: true),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return CategoryItemTile(
                    category: category,
                    index: index,
                    onEdit: () => _openAddEditSheet(existing: category),
                    onDelete: () => _handleDelete(category),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
