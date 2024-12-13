import 'package:expense_app/domain/entities/recurring.dart';
import 'package:expense_app/domain/repositories/recurring_repository.dart';

class UpdateRecurringUseCase {
  final RecurringRepository _repository;

  UpdateRecurringUseCase({
    required RecurringRepository repository,
  }) : _repository = repository;

  Future<String?> update(Recurring recurring) async {
    final result = await _repository.update(recurring);
    return result.message;
  }
}
