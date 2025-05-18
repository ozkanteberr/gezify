import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezify/presentation/home/data/category_repository.dart';
import 'package:gezify/presentation/home/presentation/cubits/category/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository repository;

  CategoryCubit({required this.repository}) : super(CategoryLoading());

  Future<void> fetchCategories() async {
    try {
      emit(CategoryLoading());
      final categories = await repository.fetchCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
