

import 'package:easy_shop/core/routing/routes.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_bottom_summary.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is CartLoaded) {
                    count = state.items.length;
                  }
                  return Text(
                    '$count ${count == 1 ? "Item" : "Items"}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (state is CartActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is CartLoaded) {
              if (state.items.isEmpty) {
                return _buildEmptyCart(context);
              }

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => context.read<CartCubit>().getCartItems(),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          final product = item.product;

                          return CartItemCard(
                            title:
                                product?.name ?? 'Product #${item.productId}',
                            category: product?.categoryName ?? 'Item',
                            price: item.price,
                            quantity: item.quantity,
                            imageUrl: product?.imageUrl,
                            onIncrement: () {
                              context.read<CartCubit>().updateQuantity(
                                productId: item.productId,
                                newQuantity: item.quantity + 1,
                              );
                            },
                            onDecrement: () {
                              if (item.quantity > 1) {
                                context.read<CartCubit>().updateQuantity(
                                  productId: item.productId,
                                  newQuantity: item.quantity - 1,
                                );
                              } else {
                                context.read<CartCubit>().removeFromCart(
                                  item.productId,
                                );
                              }
                            },
                            onDelete: () {
                              context.read<CartCubit>().removeFromCart(
                                item.productId,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  CartBottomSummary(
                    subtotal: state.subtotal,
                    total: state.total,
                    onCheckout: () =>
                        Navigator.pushNamed(context, Routes.checkout),
                  ),
                ],
              );
            }

            return _buildEmptyCart(context);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1E8),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFD5BD), width: 1.5),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore products and add items to your cart.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.clientMainNav,
                  (route) => false,
                );
              },
              child: const Text(
                'Start Shopping',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
