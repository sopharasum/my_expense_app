import 'package:expense_app/domain/usecases/income/add_income_use_case.dart';
import 'package:expense_app/domain/usecases/income/delete_income_use_case.dart';
import 'package:expense_app/domain/usecases/income/get_income_use_case.dart';
import 'package:expense_app/domain/usecases/income/update_income_use_case.dart';

class IncomeUseCases {
  GetIncomeUseCase getUseCase;
  AddIncomeUseCase addUseCase;
  UpdateIncomeUseCase updateUseCase;
  DeleteIncomeUseCase deleteUseCase;

  IncomeUseCases({
    required this.getUseCase,
    required this.addUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
  });
}
