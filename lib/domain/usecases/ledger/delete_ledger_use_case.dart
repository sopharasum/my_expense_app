import 'package:expense_app/domain/repositories/ledger_repository.dart';

class DeleteLedgerUseCase {
  final LedgerRepository _repository;

  DeleteLedgerUseCase({
    required LedgerRepository repository,
  }) : _repository = repository;

  Future<String?> delete(int? ledgerId) async {
    final result = await _repository.delete(ledgerId);
    return result.message;
  }
}
