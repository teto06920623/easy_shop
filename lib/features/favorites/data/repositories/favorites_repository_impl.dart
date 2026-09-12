

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/result.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';
import '../../../products/data/models/product_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<ProductModel>>> getFavorites() async {
    try {
      final result = await remoteDataSource.getFavorites();
      return Success(result);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<void>> addFavorite(int productId) async {
    try {
      await remoteDataSource.addFavorite(productId);
      return const Success(null);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<void>> removeFavorite(int productId) async {
    try {
      await remoteDataSource.removeFavorite(productId);
      return const Success(null);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }
}
