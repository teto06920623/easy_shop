

import 'package:easy_shop/core/di/injection_container.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/features/categories/domain/entities/category_entity.dart';
import 'package:easy_shop/features/categories/presentation/client/cubit/categories_cubit.dart';
import 'package:easy_shop/features/categories/presentation/client/cubit/categories_state.dart';
import 'package:easy_shop/features/favorites/presentation/client/cubit/favorites_cubit.dart';
import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';
import 'package:easy_shop/features/products/presentation/client/cubit/products_cubit.dart';
import 'package:easy_shop/features/products/presentation/client/cubit/products_state.dart';
import 'package:easy_shop/features/products/presentation/client/screens/products_screen.dart';
import 'package:easy_shop/features/products/presentation/client/screens/search_screen.dart';
import 'package:easy_shop/features/products/presentation/client/widgets/product_card.dart';
import 'package:easy_shop/features/profile/presentation/client/cubit/client_profile_cubit.dart';
import 'package:easy_shop/features/profile/presentation/client/cubit/client_profile_state.dart';
import 'package:easy_shop/features/profile/presentation/client/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CategoriesCubit>()..getCategories()),
        BlocProvider(create: (_) => sl<ProductsCubit>()..getProducts()),
      ],
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  int? _selectedCategoryId; 

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'GOOD MORNING';
    } else if (hour >= 12 && hour < 17) {
      return 'GOOD AFTERNOON';
    } else {
      return 'GOOD EVENING';
    }
  }

  Future<void> _onRefresh(BuildContext context) async {
    await Future.wait([
      context.read<CategoriesCubit>().getCategories(),
      context.read<ProductsCubit>().getProducts(),
      context.read<FavoritesCubit>().getFavorites(),
      context.read<ClientProfileCubit>().getProfile(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => _onRefresh(context),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<ClientProfileCubit, ClientProfileState>(
                  builder: (context, profileState) {
                    final user = (profileState is ClientProfileLoaded)
                        ? profileState.user
                        : (profileState is ClientProfileUpdateSuccess
                              ? profileState.user
                              : null);

                    final displayName = user?.name.isNotEmpty == true
                        ? user!.name
                        : 'User';
                    final pictureUrl = user?.pictureUrl;
                    final initial = displayName.isNotEmpty
                        ? displayName[0].toUpperCase()
                        : 'U';

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: const TextStyle(
                                fontSize: 10,
                                letterSpacing: 1.1,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$displayName 👋',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ClientProfileCubit>(),
                                  child: const ProfileScreen(),
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.primary,
                            backgroundImage:
                                (pictureUrl != null && pictureUrl.isNotEmpty)
                                ? NetworkImage(pictureUrl)
                                : null,
                            child: (pictureUrl == null || pictureUrl.isEmpty)
                                ? Text(
                                    initial,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Search products...',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              
              BlocBuilder<CategoriesCubit, CategoriesState>(
                builder: (context, catState) {
                  List<CategoryEntity> categories = [];
                  if (catState is CategoriesLoaded) {
                    categories = catState.categories;
                  }

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
                            if (catState is CategoriesLoading)
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
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
                          itemCount: categories.length + 1, 
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final isAll = index == 0;
                            final isSelected = isAll
                                ? _selectedCategoryId == null
                                : _selectedCategoryId ==
                                      categories[index - 1].id;

                            final label = isAll
                                ? 'All'
                                : categories[index - 1].name;

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
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProductsScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              
              BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, prodState) {
                  if (prodState is ProductsLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (prodState is ProductsError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              prodState.message,
                              style: const TextStyle(color: AppColors.error),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () =>
                                  context.read<ProductsCubit>().getProducts(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  List<ProductEntity> products = [];
                  if (prodState is ProductsLoaded) {
                    products = prodState.products;
                  }

                  
                  final displayedProducts =
                      (_selectedCategoryId == null
                              ? products
                              : products
                                    .where(
                                      (p) =>
                                          p.categoryId == _selectedCategoryId,
                                    )
                                    .toList())
                          .where((p) => p.isVisible)
                          .toList();

                  if (displayedProducts.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      child: const Text(
                        'No products available in this category',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                      itemBuilder: (context, index) {
                        return ProductCard(product: displayedProducts[index]);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
