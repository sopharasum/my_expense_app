import 'package:expense_app/data/data_sources/remote/api/ledger_api.dart';
import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/filter.dart';
import 'package:expense_app/domain/repositories/ledger_repository.dart';

class LedgerRepositoryImpl extends LedgerRepository {
  final LedgerApi _api;

  LedgerRepositoryImpl({
    required LedgerApi api,
  }) : _api = api;

  @override
  Future<ApiMessage> create(Entry ledger) async {
    return await _api.create(ledger);
  }

  @override
  Future<ApiMessage> delete(int? id) async {
    return await _api.delete(id);
  }

  @override
  Future<EntryResponse> filter(int page, int size, Filter filter) async {
    return await _api.filter(page, size, filter);
  }

  @override
  Future<EntryResponse> get(int page, int size) async {
    return await _api.get(page, size);
  }

  @override
  Future<ApiMessage> update(Entry ledger) async {
    return await _api.update(ledger);
  }
}
