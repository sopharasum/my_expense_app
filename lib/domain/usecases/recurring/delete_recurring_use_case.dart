import 'package:expense_app/domain/repositories/recurring_repository.dart';

class DeleteRecurringUseCase {
  final RecurringRepository _repository;

  DeleteRecurringUseCase({
    required RecurringRepository repository,
  }) : _repository = repository;

  Future<String?> delete(int? id) async {
    final result = await _repository.delete(id);
    return result.message;
  }
}
