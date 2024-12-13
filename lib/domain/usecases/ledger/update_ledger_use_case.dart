import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/repositories/ledger_repository.dart';

class UpdateLedgerUseCase {
  final LedgerRepository _repository;

  UpdateLedgerUseCase({
    required LedgerRepository repository,
  }) : _repository = repository;

  Future<String?> update(Entry ledger) async {
    final result = await _repository.update(ledger);
    return result.message;
  }
}
