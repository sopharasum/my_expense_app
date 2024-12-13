import 'package:expense_app/domain/usecases/category/add_category_use_case.dart';
import 'package:expense_app/domain/usecases/category/delete_category_use_case.dart';
import 'package:expense_app/domain/usecases/category/get_categories_use_case.dart';
import 'package:expense_app/domain/usecases/category/update_category_use_case.dart';

class CategoryUseCases {
  GetCategoriesUseCase getUseCase;
  AddCategoryUseCase addUseCase;
  UpdateCategoryUseCase updateUseCase;
  DeleteCategoryUseCase deleteUseCase;

  CategoryUseCases({
    required this.getUseCase,
    required this.addUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
  });
}
