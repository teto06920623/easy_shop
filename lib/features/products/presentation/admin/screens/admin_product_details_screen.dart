import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:easy_shop/features/products/presentation/admin/screens/add_edit_product_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/admin_product_description_card.dart';
import '../widgets/admin_product_meta_details_card.dart';
import '../widgets/admin_product_metrics_card.dart';

class AdminProductDetailsScreen extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String inStock;
  final bool isVisible;
  final String description;
  final String addedDate;

  const AdminProductDetailsScreen({
    super.key,
    this.title = 'Wireless Headphones',
    this.category = 'Electronics',
    this.price = '299',
    this.inStock = '45',
    this.isVisible = true,
    this.description =
        'Premium wireless headphones with active noise cancellation and 30-hour battery life.',
    this.addedDate = 'Jan 10, 2024',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 240,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE5A93B), Color(0xFFF3C053)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.headphones_rounded,
                    size: 110,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddEditProductScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 16),

                
                AdminProductMetricsCard(
                  price: price,
                  inStock: inStock,
                  isVisible: isVisible,
                ),
                const SizedBox(height: 14),

                
                AdminProductDescriptionCard(description: description),
                const SizedBox(height: 14),

                
                AdminProductMetaDetailsCard(
                  category: category,
                  addedDate: addedDate,
                ),
                const SizedBox(height: 24),

                
                CustomButton(
                  title: 'Edit Product',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddEditProductScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
