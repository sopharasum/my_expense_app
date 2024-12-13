import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/recurring.dart';
import 'package:expense_app/domain/repositories/recurring_repository.dart';

class GetRecurringUseCase {
  final RecurringRepository _repository;

  GetRecurringUseCase({
    required RecurringRepository repository,
  }) : _repository = repository;

  Future<RecurringResponse> get(int page) async {
    return await _repository.get(page, defaultSize);
  }
}
