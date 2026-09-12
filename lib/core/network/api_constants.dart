class ApiConstants {
  static const String baseUrl = 'https://easylearn.devawy.com/api/';

  
  static const String apiKey =
      'wQ9KxY7nP2LrA5FmD8TsV1BhE6JzNc4UyRg3KqXpWoMf7CdSaHt9LeIk2On8GbYu';

  
  
  static const String adminLogin = 'admin/login';
  static const String adminRegister = 'admin/register';
  static const String adminLogout = 'admin/logout';
  static const String adminVerifyOtp = 'admin/otp/verify';
  static const String adminResendOtp = 'admin/otp/resend';

  
  static const String adminProfile = 'admin/profile';
  static const String adminUpdateProfile = 'admin/profile/update';

  
  static const String adminCategories = 'admin/categories';
  static const String adminStoreCategory = 'admin/categories/store';
  static String adminUpdateCategory(String slug) =>
      'admin/categories/update/$slug';
  static String adminDeleteCategory(String slug) =>
      'admin/categories/destroy/$slug';

  
  static const String adminProducts = 'admin/products';
  static const String adminStoreProduct = 'admin/products/store';
  static String adminProductDetails(String slug) => 'admin/products/show/$slug';
  static String adminUpdateProduct(String slug) =>
      'admin/products/update/$slug';
  static String adminDeleteProduct(String slug) =>
      'admin/products/destroy/$slug';

  
  static const String adminOrders = 'admin/orders';
  static String adminOrderDetails(String code) => 'admin/orders/show/$code';

  
  
  static const String clientLogin = 'client/login';
  static const String clientRegister = 'client/register';
  static const String clientLogout = 'client/logout';
  static const String clientVerifyOtp = 'client/otp/verify';
  static const String clientResendOtp = 'client/otp/resend';

  
  static const String clientProfile = 'client/profile';
  static const String clientUpdateProfile = 'client/profile/update';

  
  static const String clientCategories = 'client/categories';
  static const String clientProducts = 'client/products';
  static String clientProductDetails(String slug) =>
      'client/products/show/$slug';

  
  static const String clientFavorites = 'client/favorites';
  static const String clientStoreFavorite = 'client/favorites/store';
  static const String clientDeleteFavorite = 'client/favorites/destroy';

  
  static const String clientCarts = 'client/carts';
  static const String clientStoreCart = 'client/carts/store';
  static const String clientDeleteCart = 'client/carts/destroy';

  
  static const String clientOrders = 'client/orders';
  static const String clientStoreOrder = 'client/orders/store';
  static String clientOrderDetails(String code) => 'client/orders/show/$code';
  static String clientPayOrder(String code) => 'client/orders/pay/$code';

  
  static const String clientProcessPayment = 'client/payments/process';
}
