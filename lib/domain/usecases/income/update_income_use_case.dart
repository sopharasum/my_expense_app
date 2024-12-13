import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/repositories/income_repository.dart';

class UpdateIncomeUseCase {
  final IncomeRepository _repository;

  UpdateIncomeUseCase({
    required IncomeRepository repository,
  }) : _repository = repository;

  Future<String?> update(Entry income) async {
    final result = await _repository.update(income);
    return result.message;
  }
}
