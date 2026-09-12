import 'package:easy_shop/core/errors/result.dart';
import 'package:easy_shop/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:easy_shop/features/favorites/presentation/client/cubit/favorites_state.dart';
import 'package:easy_shop/features/products/domain/entities/dummy_product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository favoritesRepository;

  FavoritesCubit({required this.favoritesRepository})
    : super(FavoritesInitial());

  List<ProductEntity> _favoritesList = []; 
  final Set<int> _favoriteIds = {};

  bool isFavorite(int productId) => _favoriteIds.contains(productId);

  Future<void> getFavorites() async {
    emit(FavoritesLoading());

    final result = await favoritesRepository.getFavorites();

    switch (result) {
      case Success(data: final favorites):
        _favoritesList = favorites;
        _favoriteIds.clear();
        for (var p in favorites) {
          _favoriteIds.add(p.id);
        }
        emit(FavoritesLoaded(favorites: List.from(_favoritesList)));
      case Err(failure: final failure):
        emit(FavoritesError(message: failure.message));
    }
  }

  Future<void> toggleFavorite(ProductEntity product) async {
    final bool isFav = _favoriteIds.contains(product.id);

    if (isFav) {
      _favoriteIds.remove(product.id);
      _favoritesList.removeWhere((p) => p.id == product.id);
    } else {
      _favoriteIds.add(product.id);
      _favoritesList.add(product.copyWith(isFavorite: true));
    }
    emit(FavoritesLoaded(favorites: List.from(_favoritesList)));

    final result = isFav
        ? await favoritesRepository.removeFavorite(product.id)
        : await favoritesRepository.addFavorite(product.id);

    switch (result) {
      case Success():
        break;
      case Err():
        if (isFav) {
          _favoriteIds.add(product.id);
          _favoritesList.add(product.copyWith(isFavorite: true));
        } else {
          _favoriteIds.remove(product.id);
          _favoritesList.removeWhere((p) => p.id == product.id);
        }
        emit(FavoritesLoaded(favorites: List.from(_favoritesList)));
    }
  }
}
