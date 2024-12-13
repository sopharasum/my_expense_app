import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/recurring.dart';
import 'package:expense_app/domain/repositories/recurring_repository.dart';

class AddRecurringUseCase {
  final RecurringRepository _repository;

  AddRecurringUseCase({
    required RecurringRepository repository,
  }) : _repository = repository;

  Future<ApiMessage> add(Recurring recurring) async {
    return await _repository.create(recurring);
  }
}
