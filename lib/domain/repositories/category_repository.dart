import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<CategoryResponse> get(String? type);

  Future<ApiMessage> create(Category category);

  Future<ApiMessage> update(Category category);

  Future<ApiMessage> delete(int? id);
}
