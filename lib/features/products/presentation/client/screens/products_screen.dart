

import 'package:easy_shop/core/di/injection_container.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/features/favorites/presentation/client/cubit/favorites_cubit.dart';
import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../widgets/product_card.dart';
import '../widgets/product_category_chip.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProductsCubit>()..getProducts()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()..getFavorites()),
      ],
      child: const _ProductsScreenContent(),
    );
  }
}

class _ProductsScreenContent extends StatefulWidget {
  const _ProductsScreenContent();

  @override
  State<_ProductsScreenContent> createState() => _ProductsScreenContentState();
}

class _ProductsScreenContentState extends State<_ProductsScreenContent> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Mobile Phone',
    'Mobile Covers',
    'Laptops',
    'Audio',
    'Accessories',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Products'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ProductCategoryChip(
                  label: _categories[index],
                  isSelected: _selectedCategoryIndex == index,
                  onTap: () => setState(() => _selectedCategoryIndex = index),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          
          Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
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

                
                final filteredProducts = allProducts.where((product) {
                  final matchesCategory =
                      _selectedCategoryIndex == 0 ||
                      (product.categoryName != null &&
                          product.categoryName!.toLowerCase() ==
                              _categories[_selectedCategoryIndex]
                                  .toLowerCase());

                  final matchesSearch =
                      _searchQuery.isEmpty ||
                      product.name.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      );

                  return matchesCategory && matchesSearch;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: filteredProducts[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
