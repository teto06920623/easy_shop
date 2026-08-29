import 'package:get_it/get_it.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
// import '../../features/cart/presentation/cubit/cart_cubit.dart';
// import '../../features/categories/presentation/cubit/categories_cubit.dart';
// import '../../features/checkout/presentation/cubit/checkout_cubit.dart';
// import '../../features/favorites/presentation/cubit/favorites_cubit.dart';
// import '../../features/home/presentation/cubit/home_cubit.dart';
// import '../../features/maps/presentation/cubit/maps_cubit.dart';
// import '../../features/orders/presentation/cubit/orders_cubit.dart';
// import '../../features/products/presentation/cubit/products_cubit.dart';
// import '../../features/profile/presentation/cubit/profile_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ================= Cubits =================
  sl.registerFactory(() => AuthCubit());
  // sl.registerFactory(() => HomeCubit());
  // sl.registerFactory(() => CategoriesCubit());
  // sl.registerFactory(() => ProductsCubit());
  // sl.registerFactory(() => CartCubit());
  // sl.registerFactory(() => FavoritesCubit());
  // sl.registerFactory(() => CheckoutCubit());
  // sl.registerFactory(() => OrdersCubit());
  // sl.registerFactory(() => ProfileCubit());
  // sl.registerFactory(() => MapsCubit());

}
