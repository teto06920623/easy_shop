import 'package:easy_shop/core/routing/routes.dart';
import 'package:easy_shop/features/auth/presentation/admin/cubit/admin_auth_cubit.dart';
import 'package:easy_shop/features/auth/presentation/admin/screens/admin_login_screen.dart';
import 'package:easy_shop/features/auth/presentation/admin/screens/admin_register_screen.dart';
import 'package:easy_shop/features/auth/presentation/client/cubit/auth_cubit.dart';
import 'package:easy_shop/features/auth/presentation/client/screens/client_login_screen.dart';
import 'package:easy_shop/features/auth/presentation/client/screens/client_register_screen.dart';
import 'package:easy_shop/features/auth/presentation/shared/cubit/auth_ui_cubit.dart';
import 'package:easy_shop/features/auth/presentation/shared/screens/otp_verification_screen.dart';
import 'package:easy_shop/features/auth/presentation/shared/screens/splash_screen.dart';
import 'package:easy_shop/features/auth/presentation/shared/screens/welcome_success_screen.dart';
import 'package:easy_shop/features/cart/presentation/client/cubit/cart_cubit.dart';
import 'package:easy_shop/features/cart/presentation/client/screens/cart_screen.dart';
import 'package:easy_shop/features/checkout/presentation/client/screens/checkout_screen.dart';
import 'package:easy_shop/features/favorites/presentation/client/cubit/favorites_cubit.dart';
import 'package:easy_shop/features/home/presentation/admin/cubit/admin_home_cubit.dart';
import 'package:easy_shop/features/home/presentation/admin/screens/admin_main_navigation_screen.dart';
import 'package:easy_shop/features/home/presentation/client/cubit/home_cubit.dart';
import 'package:easy_shop/features/home/presentation/client/screens/main_navigation_screen.dart';
import 'package:easy_shop/features/orders/presentation/admin/cubit/admin_order_cubit.dart';
import 'package:easy_shop/features/orders/presentation/client/cubit/client_order_cubit.dart';
import 'package:easy_shop/features/products/presentation/client/cubit/products_cubit.dart';
import 'package:easy_shop/features/products/presentation/client/screens/product_details_screen.dart';
import 'package:easy_shop/features/profile/presentation/admin/cubit/admin_profile_cubit.dart';
import 'package:easy_shop/features/profile/presentation/client/cubit/client_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/injection_container.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.clientLogin:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<ClientAuthCubit>()),
              BlocProvider(create: (_) => sl<AuthUiCubit>()),
            ],
            child: const ClientLoginScreen(),
          ),
        );

      case Routes.clientRegister:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ClientAuthCubit>(),
            child: const RegisterScreen(),
          ),
        );

      case Routes.adminLogin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<AdminAuthCubit>(),
            child: const AdminLoginScreen(),
          ),
        );

      case Routes.adminRegister:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<AdminAuthCubit>(),
            child: const AdminRegisterScreen(),
          ),
        );

      case Routes.otpVerification:
        final args = arguments as Map<String, dynamic>? ?? {};
        final role = args['role'] ?? 'client';
        return MaterialPageRoute(
          builder: (_) =>
              OtpVerificationScreen(email: args['email'] ?? '', role: role),
        );

      case Routes.welcomeSuccess:
        final role = arguments as String? ?? 'client';
        return MaterialPageRoute(
          builder: (_) => WelcomeSuccessScreen(role: role),
        );

      case Routes.clientMainNav:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl<ClientHomeCubit>()..fetchHomeData(),
              ),
              BlocProvider(create: (_) => sl<FavoritesCubit>()..getFavorites()),
              BlocProvider.value(value: sl<CartCubit>()..getCartItems()),
              BlocProvider(create: (_) => sl<ClientOrderCubit>()),
              BlocProvider(
                create: (_) => sl<ClientProfileCubit>()..getProfile(),
              ),
            ],
            child: const MainNavigationScreen(),
          ),
        );

      case Routes.adminMainNav:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl<AdminHomeCubit>()..fetchDashboardData(),
              ),
              BlocProvider(create: (_) => sl<AdminOrderCubit>()),
              BlocProvider(
                create: (_) => sl<AdminProfileCubit>()..getProfile(),
              ),
            ],
            child: const AdminMainNavigationScreen(),
          ),
        );

      case Routes.productDetails:
        final slug = arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl<ProductsCubit>()..getProductDetails(slug),
              ),
              BlocProvider.value(value: sl<CartCubit>()),
              BlocProvider.value(value: sl<FavoritesCubit>()),
            ],
            child: ProductDetailsScreen(slug: slug),
          ),
        );
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case Routes.checkout:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ClientOrderCubit>(),
            child: CheckoutScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
