import 'package:get_it/get_it.dart';


import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_client_usecase.dart';
import '../../features/auth/domain/usecases/register_merchant_usecase.dart';
import '../../features/auth/domain/usecases/resend_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/admin/cubit/admin_auth_cubit.dart';
import '../../features/auth/presentation/client/cubit/auth_cubit.dart';
import '../../features/auth/presentation/shared/cubit/auth_ui_cubit.dart';


import '../../features/categories/data/datasources/categories_remote_data_source.dart';
import '../../features/categories/data/repositories/categories_repository_impl.dart';
import '../../features/categories/domain/repositories/categories_repository.dart';
import '../../features/categories/domain/usecases/create_category_usecase.dart';
import '../../features/categories/domain/usecases/delete_category_usecase.dart';
import '../../features/categories/domain/usecases/get_categories_usecase.dart';
import '../../features/categories/domain/usecases/update_category_usecase.dart';
import '../../features/categories/presentation/client/cubit/categories_cubit.dart';


import '../../features/products/data/datasources/products_remote_data_source.dart';
import '../../features/products/data/repositories/products_repository_impl.dart';
import '../../features/products/domain/repositories/products_repository.dart';
import '../../features/products/domain/usecases/create_product_usecase.dart';
import '../../features/products/domain/usecases/delete_product_usecase.dart';
import '../../features/products/domain/usecases/get_product_details_usecase.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/update_product_usecase.dart';
import '../../features/products/presentation/client/cubit/products_cubit.dart';


import '../../features/favorites/data/datasources/favorites_remote_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/presentation/client/cubit/favorites_cubit.dart';


import '../../features/cart/data/datasources/cart_remote_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/presentation/client/cubit/cart_cubit.dart';


import '../../features/checkout/data/datasources/checkout_remote_data_source.dart';
import '../../features/checkout/data/repositories/checkout_repository_impl.dart';
import '../../features/checkout/domain/repositories/checkout_repository.dart';
import '../../features/checkout/domain/usecases/create_order_usecase.dart';
import '../../features/checkout/domain/usecases/pay_order_usecase.dart';
import '../../features/checkout/domain/usecases/process_payment_usecase.dart';
import '../../features/checkout/presentation/client/cubit/checkout_cubit.dart';


import '../../features/orders/data/datasources/orders_remote_data_source.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/get_order_details_usecase.dart';
import '../../features/orders/domain/usecases/get_orders_usecase.dart';
import '../../features/orders/presentation/admin/cubit/admin_order_cubit.dart';
import '../../features/orders/presentation/client/cubit/client_order_cubit.dart';


import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_admin_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_client_profile_usecase.dart';
import '../../features/profile/presentation/admin/cubit/admin_profile_cubit.dart';
import '../../features/profile/presentation/client/cubit/client_profile_cubit.dart';


import '../../features/home/presentation/admin/cubit/admin_home_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterClientUseCase(sl()));
  sl.registerLazySingleton(() => RegisterMerchantUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl()));

  sl.registerFactory<AuthUiCubit>(() => AuthUiCubit());
  sl.registerFactory<ClientAuthCubit>(
    () => ClientAuthCubit(
      loginUseCase: sl(),
      registerClientUseCase: sl(),
      verifyOtpUseCase: sl(),
      resendOtpUseCase: sl(),
    ),
  );
  sl.registerFactory<AdminAuthCubit>(
    () => AdminAuthCubit(
      loginUseCase: sl(),
      registerMerchantUseCase: sl(),
      verifyOtpUseCase: sl(),
      resendOtpUseCase: sl(),
    ),
  );

  
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => CreateCategoryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCategoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));

  sl.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(
      getCategoriesUseCase: sl(),
      createCategoryUseCase: sl(),
      updateCategoryUseCase: sl(),
      deleteCategoryUseCase: sl(),
    ),
  );

  
  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));
  sl.registerLazySingleton(() => CreateProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));

  sl.registerFactory<ProductsCubit>(
    () => ProductsCubit(
      getProductsUseCase: sl(),
      getProductDetailsUseCase: sl(),
      createProductUseCase: sl(),
      updateProductUseCase: sl(),
      deleteProductUseCase: sl(),
    ),
  );

  
  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(favoritesRepository: sl()),
  );

  
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CartCubit>(() => CartCubit(cartRepository: sl()));

  
  sl.registerLazySingleton<CheckoutRemoteDataSource>(
    () => CheckoutRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton(() => PayOrderUseCase(sl()));
  sl.registerLazySingleton(() => ProcessPaymentUseCase(sl()));

  sl.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(createOrderUseCase: sl(), payOrderUseCase: sl()),
  );

  
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderDetailsUseCase(sl()));

  sl.registerFactory<AdminOrderCubit>(
    () => AdminOrderCubit(getOrdersUseCase: sl(), getOrderDetailsUseCase: sl()),
  );
  sl.registerFactory<ClientOrderCubit>(
    () =>
        ClientOrderCubit(getOrdersUseCase: sl(), getOrderDetailsUseCase: sl()),
  );

  
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateClientProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAdminProfileUseCase(sl()));

  sl.registerFactory<ClientProfileCubit>(
    () => ClientProfileCubit(
      getProfileUseCase: sl(),
      updateClientProfileUseCase: sl(),
    ),
  );
  sl.registerFactory<AdminProfileCubit>(
    () => AdminProfileCubit(
      getProfileUseCase: sl(),
      updateAdminProfileUseCase: sl(),
    ),
  );

  
  sl.registerFactory<AdminHomeCubit>(
    () => AdminHomeCubit(getCategoriesUseCase: sl(), getProductsUseCase: sl()),
  );
}
