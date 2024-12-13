import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/domain/repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _repository;

  GetCategoriesUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  Future<List<Category>> get(String? type) async {
    final List<Category> categories = [];
    await _repository.get(type).then((response) {
      categories.addAll(response.data);
    });
    return categories;
  }
}
