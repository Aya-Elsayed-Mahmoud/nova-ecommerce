import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../models/product_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final Dio _dio = Dio();

  void fetchProducts() async {
    emit(HomeLoading());
    try {
      // ده رابط الـ API الخاص بيك والمطلوب في مشروعكم
      final response = await _dio.get('https://accessories-eshop.runasp.net/api/products');

      List<ProductModel> products = (response.data as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
      emit(HomeLoaded(products));
    } catch (e) {
      // دي بيانات احتياطية لو السيرفر فيه مشكلة مؤقتة عشان التصميم مايعطلش
      List<ProductModel> dummyProducts = [
        ProductModel(id: 1, title: 'Structural Leather Tote', price: 12450, imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3'),
        ProductModel(id: 2, title: 'Oversized Wool Blazer', price: 18900, imageUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6'),
      ];
      emit(HomeLoaded(dummyProducts));
    }
  }
}