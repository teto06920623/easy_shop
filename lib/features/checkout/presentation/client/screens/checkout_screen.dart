import 'package:easy_shop/core/di/injection_container.dart';
import 'package:easy_shop/core/helpers/secure_storage_helper.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:easy_shop/features/cart/data/models/cart_item_model.dart';
import 'package:easy_shop/features/cart/presentation/client/cubit/cart_cubit.dart';
import 'package:easy_shop/features/cart/presentation/client/cubit/cart_state.dart';
import 'package:easy_shop/features/maps/presentation/client/screens/map_picker_screen.dart';
import 'package:easy_shop/features/profile/presentation/client/cubit/client_profile_cubit.dart';
import 'package:easy_shop/features/profile/presentation/client/cubit/client_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/checkout_cubit.dart';
import '../cubit/checkout_state.dart';
import '../widgets/checkout_delivery_address.dart';
import '../widgets/checkout_item_tile.dart';
import '../widgets/checkout_order_summary_card.dart';
import '../widgets/checkout_payment_method_tile.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<CartCubit>()..getCartItems()),
        BlocProvider(create: (_) => sl<CheckoutCubit>()),
        BlocProvider(create: (_) => sl<ClientProfileCubit>()..getProfile()),
      ],
      child: const _CheckoutScreenContent(),
    );
  }
}

class _CheckoutScreenContent extends StatefulWidget {
  const _CheckoutScreenContent();

  @override
  State<_CheckoutScreenContent> createState() => _CheckoutScreenContentState();
}

class _CheckoutScreenContentState extends State<_CheckoutScreenContent> {
  int _selectedPaymentMethod = 0; 

  String _deliveryAddress = '';
  double _latitude = 30.033333;
  double _longitude = 31.233334;
  bool _addressInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadInitialAddress();
  }

  
  Future<void> _loadInitialAddress() async {
    final savedAddress = await SecureStorageHelper.getUserAddress();
    final savedLat = await SecureStorageHelper.getUserLatitude();
    final savedLng = await SecureStorageHelper.getUserLongitude();

    if (savedAddress != null && savedAddress.trim().isNotEmpty && mounted) {
      setState(() {
        _deliveryAddress = savedAddress;
        if (savedLat != null) _latitude = savedLat;
        if (savedLng != null) _longitude = savedLng;
        _addressInitialized = true;
      });
    }

    
    if (mounted) {
      final profileState = context.read<ClientProfileCubit>().state;
      if (profileState is ClientProfileLoaded &&
          profileState.user.address != null &&
          profileState.user.address!.isNotEmpty) {
        _applyAddress(
          address: profileState.user.address!,
          lat: profileState.user.latitude,
          lng: profileState.user.longitude,
        );
      }
    }
  }

  void _applyAddress({required String address, double? lat, double? lng}) {
    setState(() {
      _deliveryAddress = address;
      if (lat != null) _latitude = lat;
      if (lng != null) _longitude = lng;
      _addressInitialized = true;
    });
    SecureStorageHelper.saveUserAddress(address);
    if (lat != null && lng != null) {
      SecureStorageHelper.saveUserLocation(lat, lng);
    }
  }

  void _onPlaceOrder(List<CartItemModel> items) {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_deliveryAddress.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a delivery address first.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final productIds = items.map((e) => e.productId).toList();
    final quantities = items.map((e) => e.quantity).toList();
    final prices = items.map((e) => e.price * e.quantity).toList();
    final paymentMethod = _selectedPaymentMethod == 0 ? 'cash' : 'card';

    context.read<CheckoutCubit>().submitOrder(
      productIds: productIds,
      quantities: quantities,
      prices: prices,
      address: _deliveryAddress,
      latitude: _latitude,
      longitude: _longitude,
      paymentMethod: paymentMethod,
    );
  }

  Future<void> _changeLocation() async {
    final result = await Navigator.push<MapPickerResult>(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
    );
    if (result != null) {
      _applyAddress(
        address: result.address,
        lat: result.latitude,
        lng: result.longitude,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Checkout'),
      ),
      body: BlocListener<ClientProfileCubit, ClientProfileState>(
        listener: (context, profileState) {
          if (!_addressInitialized &&
              profileState is ClientProfileLoaded &&
              profileState.user.address != null &&
              profileState.user.address!.isNotEmpty) {
            _applyAddress(
              address: profileState.user.address!,
              lat: profileState.user.latitude,
              lng: profileState.user.longitude,
            );
          }
        },

        child: BlocListener<CheckoutCubit, CheckoutState>(
          listener: (context, checkoutState) {
            if (checkoutState is CheckoutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(checkoutState.message),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (checkoutState is CheckoutOrderPlacedSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderSuccessScreen(
                    orderCode: checkoutState.order.orderCode,
                  ),
                ),
                (route) => route.isFirst,
              );
            } else if (checkoutState is CheckoutPaymentUrlReady) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderSuccessScreen(
                    orderCode: checkoutState.order.orderCode,
                  ),
                ),
                (route) => route.isFirst,
              );
            }
          },
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              if (cartState is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              List<CartItemModel> items = [];
              double subtotal = 0.0;
              double total = 0.0;

              if (cartState is CartLoaded) {
                items = cartState.items;
                subtotal = cartState.subtotal;
                total = cartState.total;
              }

              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            CheckoutDeliveryAddress(
                              address: _deliveryAddress.isEmpty
                                  ? 'No address selected'
                                  : _deliveryAddress,
                              onChangeLocation: _changeLocation,
                            ),
                            const SizedBox(height: 20),

                            
                            Text(
                              'Order Items (${items.length})',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),

                            if (items.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'No items found in cart',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            else
                              ...items.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: CheckoutItemTile(
                                    title:
                                        item.product?.name ??
                                        'Product #${item.productId}',
                                    price:
                                        '${(item.price * item.quantity).toInt()} EGP',
                                  ),
                                ),
                              ),

                            const SizedBox(height: 16),

                            
                            const Text(
                              'Payment Method',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CheckoutPaymentMethodTile(
                              icon: Icons.money_rounded,
                              title: 'Cash on Delivery',
                              isSelected: _selectedPaymentMethod == 0,
                              onTap: () =>
                                  setState(() => _selectedPaymentMethod = 0),
                            ),
                            const SizedBox(height: 8),
                            CheckoutPaymentMethodTile(
                              icon: Icons.credit_card_rounded,
                              title: 'Credit / Debit Card',
                              isSelected: _selectedPaymentMethod == 1,
                              onTap: () =>
                                  setState(() => _selectedPaymentMethod = 1),
                            ),
                            const SizedBox(height: 20),

                            
                            const Text(
                              'Order Summary',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CheckoutOrderSummaryCard(
                              itemsCount: items.length,
                              itemsPrice: subtotal,
                              totalPrice: total,
                            ),
                          ],
                        ),
                      ),
                    ),

                    
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: BlocBuilder<CheckoutCubit, CheckoutState>(
                        builder: (context, checkoutState) {
                          final isLoading = checkoutState is CheckoutLoading;

                          return CustomButton(
                            title: _selectedPaymentMethod == 0
                                ? 'Place Order'
                                : 'Proceed to Payment',
                            isLoading: isLoading,
                            onPressed: items.isEmpty
                                ? null
                                : () => _onPlaceOrder(items),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
