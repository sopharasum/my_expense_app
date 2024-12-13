import 'package:expense_app/domain/repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository _repository;

  DeleteCategoryUseCase({
    required CategoryRepository repository,
  }) : _repository = repository;

  Future<String?> delete(int? categoryId) async {
    final result = await _repository.delete(categoryId);
    return result.message;
  }
}
