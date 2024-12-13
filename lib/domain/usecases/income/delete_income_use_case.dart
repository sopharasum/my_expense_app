import 'package:expense_app/domain/repositories/income_repository.dart';

class DeleteIncomeUseCase {
  final IncomeRepository _repository;

  DeleteIncomeUseCase({
    required IncomeRepository repository,
  }) : _repository = repository;

  Future<String?> delete(int? incomeId) async {
    final result = await _repository.delete(incomeId);
    return result.message;
  }
}
