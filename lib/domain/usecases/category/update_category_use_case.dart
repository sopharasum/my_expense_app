import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/domain/repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository _repository;

  UpdateCategoryUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  Future<String?> update(Category category) async {
    final result = await _repository.update(category);
    return result.message;
  }
}
