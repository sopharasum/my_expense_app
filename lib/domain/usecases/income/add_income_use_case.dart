import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/repositories/income_repository.dart';

class AddIncomeUseCase {
  final IncomeRepository _repository;

  AddIncomeUseCase({
    required IncomeRepository repository,
  }) : _repository = repository;

  Future<String?> add(Entry income) async {
    final result = await _repository.create(income);
    return result.message;
  }
}
