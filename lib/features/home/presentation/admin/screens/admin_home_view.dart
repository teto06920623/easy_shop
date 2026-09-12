

import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/features/categories/presentation/admin/screens/manage_categories_screen.dart';
import 'package:easy_shop/features/categories/presentation/client/cubit/categories_cubit.dart';
import 'package:easy_shop/features/home/presentation/admin/cubit/admin_home_cubit.dart';
import 'package:easy_shop/features/home/presentation/admin/cubit/admin_home_state.dart';
import 'package:easy_shop/features/products/presentation/admin/screens/add_edit_product_screen.dart';
import 'package:easy_shop/features/products/presentation/client/cubit/products_cubit.dart';
import 'package:easy_shop/features/profile/presentation/admin/cubit/admin_profile_cubit.dart';
import 'package:easy_shop/features/profile/presentation/admin/cubit/admin_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/admin_product_overview_card.dart';
import '../widgets/admin_stat_card.dart';

class AdminHomeView extends StatefulWidget {
  final VoidCallback? onGoToOrders;
  final VoidCallback? onGoToProducts;
  
  AdminHomeView({super.key, this.onGoToOrders, this.onGoToProducts});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  @override
  void initState() {
    super.initState();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning,';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'M';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<AdminHomeCubit, AdminHomeState>(
        builder: (context, state) {
          final categoriesCount = state is AdminHomeLoaded
              ? state.categories.length
              : 0;
          final productsCount = state is AdminHomeLoaded
              ? state.products.length
              : 0;
          final products = state is AdminHomeLoaded ? state.products : [];
          final isError = state is AdminHomeError;
          final errorMessage = state is AdminHomeError ? state.message : '';
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await Future.wait([
                context.read<AdminHomeCubit>().fetchDashboardData(),
                context.read<AdminProfileCubit>().getProfile(),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      20,
                      MediaQuery.of(context).padding.top + 16,
                      20,
                      24,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                    ),
                    child: BlocBuilder<AdminProfileCubit, AdminProfileState>(
                      builder: (context, profileState) {
                        final user = (profileState is AdminProfileLoaded)
                            ? profileState.user
                            : (profileState is AdminProfileUpdateSuccess
                                  ? profileState.user
                                  : null);

                        final name = user?.name.isNotEmpty == true
                            ? user!.name
                            : 'Merchant';
                        final pictureUrl = user?.pictureUrl;
                        final initials = _getInitials(name);

                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  (pictureUrl != null && pictureUrl.isNotEmpty)
                                  ? NetworkImage(pictureUrl)
                                  : null,
                              child: (pictureUrl == null || pictureUrl.isEmpty)
                                  ? Text(
                                      initials,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getGreeting(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Row(
                          children: [
                            Expanded(
                              child: AdminStatCard(
                                count: '$productsCount',
                                title: 'Total Products',
                                icon: Icons.inventory_2_outlined,
                                iconColor: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: AdminStatCard(
                                count: '—',
                                title: 'Total Orders',
                                icon: Icons.local_shipping_outlined,
                                iconColor: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Expanded(
                              child: AdminStatCard(
                                count: '—',
                                title: 'Pending Orders',
                                icon: Icons.access_time_rounded,
                                iconColor: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AdminStatCard(
                                count: '$categoriesCount',
                                title: 'Categories',
                                icon: Icons.category_outlined,
                                iconColor: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider.value(
                                              value: context
                                                  .read<ProductsCubit>(),
                                            ),
                                            BlocProvider.value(
                                              value: context
                                                  .read<CategoriesCubit>(),
                                            ),
                                          ],
                                          child: const AddEditProductScreen(),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text(
                                    'Add Product',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.textDark,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context
                                              .read<CategoriesCubit>(),
                                          child: const ManageCategoriesScreen(),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.category_outlined,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  label: const Text(
                                    'Categories',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Products Overview',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.onGoToProducts,
                              child: const Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        if (state is AdminHomeLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        else if (isError)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  errorMessage.isEmpty
                                      ? 'Failed to load products.'
                                      : errorMessage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: () => context
                                      .read<AdminHomeCubit>()
                                      .fetchDashboardData(),
                                  icon: const Icon(
                                    Icons.refresh,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  label: const Text(
                                    'Retry',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (products.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'No products yet.',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          )
                        else
                          ...products
                              .take(5)
                              .map(
                                (p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: AdminProductOverviewCard(
                                    title: p.name,
                                    priceQty:
                                        '${p.price.toInt()} · Qty ${p.quantity}',
                                    isVisible: p.isVisible,
                                    imageUrl: p.imageUrl,
                                    icon: Icons.shopping_bag_outlined,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
