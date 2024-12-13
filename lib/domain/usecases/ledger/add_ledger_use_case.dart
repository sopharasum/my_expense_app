import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/repositories/ledger_repository.dart';

class AddLedgerUseCase {
  final LedgerRepository _repository;

  AddLedgerUseCase({
    required LedgerRepository repository,
  }) : _repository = repository;

  Future<String?> add(Entry ledger) async {
    final result = await _repository.create(ledger);
    return result.message;
  }
}
