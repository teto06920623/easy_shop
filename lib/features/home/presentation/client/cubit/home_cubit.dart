import 'package:easy_shop/features/home/presentation/client/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/home_remote_data_source.dart';

class ClientHomeCubit extends Cubit<ClientHomeState> {
  final HomeRemoteDataSource remoteDataSource;

  ClientHomeCubit({required this.remoteDataSource})
    : super(ClientHomeInitial());

  Future<void> fetchHomeData() async {
    emit(ClientHomeLoading());
    try {
      final results = await Future.wait([
        remoteDataSource.getCategories(isAdmin: false),
        remoteDataSource.getProducts(isAdmin: false),
      ]);
      emit(
        ClientHomeLoaded(
          categories: results[0] as dynamic,
          products: results[1] as dynamic,
        ),
      );
    } catch (e) {
      emit(ClientHomeError(e.toString()));
    }
  }

  Future<void> toggleFavorite(int productId, bool currentFav) async {
    try {
      await remoteDataSource.toggleFavorite(
        productId: productId,
        isFav: currentFav,
      );
      emit(
        ClientHomeActionSuccess(
          currentFav ? 'Removed from favorites' : 'Added to favorites',
        ),
      );
    } catch (e) {
      emit(ClientHomeError(e.toString()));
    }
  }

  Future<void> addToCart(int productId) async {
    try {
      await remoteDataSource.addToCart(productId: productId, quantity: 1);
      emit(ClientHomeActionSuccess('Added to cart successfully'));
    } catch (e) {
      emit(ClientHomeError(e.toString()));
    }
  }
}
