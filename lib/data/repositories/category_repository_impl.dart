import 'package:expense_app/data/data_sources/remote/api/category_api.dart';
import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final CategoryApi _api;

  CategoryRepositoryImpl({
    required CategoryApi api,
  }) : _api = api;

  @override
  Future<ApiMessage> create(Category category) async {
    return await _api.create(category);
  }

  @override
  Future<ApiMessage> delete(int? id) async {
    return await _api.delete(id);
  }

  @override
  Future<CategoryResponse> get(String? type) async {
    return await _api.get(type);
  }

  @override
  Future<ApiMessage> update(Category category) async {
    return await _api.update(category);
  }
}
