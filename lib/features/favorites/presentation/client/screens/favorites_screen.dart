

import 'package:easy_shop/core/routing/routes.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/error_view.dart';
import 'package:easy_shop/core/widgets/loading_indicator.dart';
import 'package:easy_shop/features/favorites/presentation/client/cubit/favorites_cubit.dart';
import 'package:easy_shop/features/favorites/presentation/client/cubit/favorites_state.dart';
import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5), 
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<FavoritesCubit, dynamic>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const LoadingIndicator();
          }

          if (state is FavoritesError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<FavoritesCubit>().getFavorites(),
            );
          }

          List<ProductEntity> favorites = [];
          if (state is FavoritesLoaded) {
            favorites =
                (state as dynamic).favorites ??
                (state as dynamic).products ??
                [];
          }

          
          if (favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1E8),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFD5BD),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 34,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Save products you love and find them here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => context.read<FavoritesCubit>().getFavorites(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = favorites[index];
                return _buildFavoriteCard(product);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoriteCard(ProductEntity product) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.productDetails,
          arguments: product.slug,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(
                  0xFF5B8DEF,
                ), 
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:
                    (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.phone_android_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      )
                    : const Icon(
                        Icons.phone_android_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
              ),
            ),
            const SizedBox(width: 14),

            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.categoryName ?? 'Category',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toInt()} EGP',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (product.storeName != null &&
                      product.storeName!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'by ${product.storeName}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFE53935),
                size: 20,
              ),
              onPressed: () {
                context.read<FavoritesCubit>().toggleFavorite(product);
              },
            ),
          ],
        ),
      ),
    );
  }
}
