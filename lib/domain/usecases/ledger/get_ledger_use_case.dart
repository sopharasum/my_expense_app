import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/filter.dart';
import 'package:expense_app/domain/repositories/ledger_repository.dart';

class GetLedgerUseCase {
  final LedgerRepository _repository;

  GetLedgerUseCase({
    required LedgerRepository repository,
  }) : _repository = repository;

  Future<EntryResponse> get(int page) async {
    return await _repository.get(page, defaultSize);
  }

  Future<EntryResponse> filter(int page, Filter filter) async {
    return await _repository.filter(page, defaultSize, filter);
  }
}
