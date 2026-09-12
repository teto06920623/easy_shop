import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/result.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<CartItemModel>>> getCartItems() async {
    try {
      final result = await remoteDataSource.getCartItems();
      return Success(result);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<void>> addToCart({
    required int productId,
    required int quantity,
  }) async {
    try {
      await remoteDataSource.addToCart(
        productId: productId,
        quantity: quantity,
      );
      return const Success(null);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<void>> removeFromCart(int productId) async {
    try {
      await remoteDataSource.removeFromCart(productId);
      return const Success(null);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }
}
