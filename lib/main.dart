import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
// import 'features/cart/presentation/cubit/cart_cubit.dart';
// import 'features/categories/presentation/cubit/categories_cubit.dart';
// import 'features/checkout/presentation/cubit/checkout_cubit.dart';
// import 'features/favorites/presentation/cubit/favorites_cubit.dart';
// import 'features/home/presentation/cubit/home_cubit.dart';
// import 'features/maps/presentation/cubit/maps_cubit.dart';
// import 'features/orders/presentation/cubit/orders_cubit.dart';
// import 'features/products/presentation/cubit/products_cubit.dart';
// import 'features/profile/presentation/cubit/profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة الـ Dependency Injection (GetIt)
  await di.init();

  runApp(const EasyShopApp());
}

class EasyShopApp extends StatelessWidget {
  const EasyShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>(),
        ),
        // BlocProvider<HomeCubit>(
        //   create: (_) => di.sl<HomeCubit>(),
        // ),
        // BlocProvider<CategoriesCubit>(
        //   create: (_) => di.sl<CategoriesCubit>(),
        // ),
        // BlocProvider<ProductsCubit>(
        //   create: (_) => di.sl<ProductsCubit>(),
        // ),
        // BlocProvider<CartCubit>(
        //   create: (_) => di.sl<CartCubit>(),
        // ),
        // BlocProvider<FavoritesCubit>(
        //   create: (_) => di.sl<FavoritesCubit>(),
        // ),
        // BlocProvider<CheckoutCubit>(
        //   create: (_) => di.sl<CheckoutCubit>(),
        // ),
        // BlocProvider<OrdersCubit>(
        //   create: (_) => di.sl<OrdersCubit>(),
        // ),
        // BlocProvider<ProfileCubit>(
        //   create: (_) => di.sl<ProfileCubit>(),
        // ),
        // BlocProvider<MapsCubit>(
        //   create: (_) => di.sl<MapsCubit>(),
        // ),
      ],
      child: MaterialApp(
        title: 'Easy Shop',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}