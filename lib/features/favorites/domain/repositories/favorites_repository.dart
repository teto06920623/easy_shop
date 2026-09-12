

import '../../../../core/errors/result.dart';
import '../../../products/data/models/product_model.dart';

abstract class FavoritesRepository {
  Future<Result<List<ProductModel>>> getFavorites();
  Future<Result<void>> addFavorite(int productId);
  Future<Result<void>> removeFavorite(int productId);
}
