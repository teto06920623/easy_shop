import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/features/cart/presentation/client/cubit/cart_cubit.dart';
import 'package:easy_shop/features/cart/presentation/client/cubit/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBadgeIcon extends StatelessWidget {
  final bool isSelected;
  final Color? color;

  const CartBadgeIcon({super.key, this.isSelected = false, this.color});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        
        int itemCount = 0;
        if (state is CartLoaded) {
          itemCount = state.items.length;
          
          
        }

        final activeColor =
            color ?? (isSelected ? AppColors.primary : AppColors.textMuted);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              isSelected
                  ? Icons.shopping_cart_rounded
                  : Icons.shopping_cart_outlined,
              color: activeColor,
              size: 24,
            ),
            if (itemCount > 0)
              Positioned(
                right: -6,
                top: -5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFE53935,
                    ), 
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.2),
                  ),
                  child: Center(
                    child: Text(
                      itemCount > 99 ? '99+' : '$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
