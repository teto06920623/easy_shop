import 'package:easy_shop/core/di/injection_container.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/empty_state_view.dart';
import 'package:easy_shop/core/widgets/loading_indicator.dart';
import 'package:easy_shop/features/categories/domain/entities/category_entity.dart';
import 'package:easy_shop/features/categories/presentation/client/cubit/categories_cubit.dart';
import 'package:easy_shop/features/categories/presentation/client/cubit/categories_state.dart';
import 'package:easy_shop/features/favorites/presentation/client/cubit/favorites_cubit.dart';
import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';
import 'package:easy_shop/features/products/presentation/client/cubit/products_cubit.dart';
import 'package:easy_shop/features/products/presentation/client/cubit/products_state.dart';
import 'package:easy_shop/features/products/presentation/client/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProductsCubit>()..getProducts()),
        BlocProvider(create: (_) => sl<CategoriesCubit>()..getCategories()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()..getFavorites()),
      ],
      child: const _SearchScreenContent(),
    );
  }
}

class _SearchScreenContent extends StatefulWidget {
  const _SearchScreenContent();

  @override
  State<_SearchScreenContent> createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<_SearchScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search Products'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: false,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ),

            
            BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                List<CategoryEntity> categories = [];
                if (state is CategoriesLoaded) {
                  categories = state.categories;
                }

                if (categories.isEmpty && state is CategoriesLoading) {
                  return const SizedBox(height: 38);
                }

                return SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length + 1,
                    
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final isAll = index == 0;
                      final isSelected = isAll
                          ? _selectedCategoryId == null
                          : _selectedCategoryId == categories[index - 1].id;

                      final label = isAll ? 'All' : categories[index - 1].name;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = isAll
                                ? null
                                : categories[index - 1].id;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textDark,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const LoadingIndicator();
                  }

                  if (state is ProductsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    );
                  }

                  List<ProductEntity> allProducts = [];
                  if (state is ProductsLoaded) {
                    allProducts = state.products;
                  }

                  final query = _searchController.text.trim().toLowerCase();

                  
                  final results = allProducts.where((product) {
                    
                    if (!product.isVisible) return false;

                    
                    if (_selectedCategoryId != null &&
                        product.categoryId != _selectedCategoryId) {
                      return false;
                    }

                    
                    if (query.isNotEmpty) {
                      final inName = product.name.toLowerCase().contains(query);
                      final inDesc =
                          product.description?.toLowerCase().contains(query) ??
                          false;
                      if (!inName && !inDesc) return false;
                    }

                    return true;
                  }).toList();

                  if (results.isEmpty) {
                    return const EmptyStateView(
                      title: 'No Products Found',
                      description:
                          'Try searching with different keywords or change the category filter.',
                      icon: Icons.search_off_rounded,
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    itemCount: results.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                    itemBuilder: (context, index) {
                      return ProductCard(product: results[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
