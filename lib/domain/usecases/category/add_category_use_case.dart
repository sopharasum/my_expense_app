import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/domain/repositories/category_repository.dart';

class AddCategoryUseCase {
  final CategoryRepository _repository;

  AddCategoryUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  Future<String?> add(Category category) async {
    final result = await _repository.create(category);
    return result.message;
  }
}
