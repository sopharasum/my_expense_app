import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/filter.dart';

abstract class LedgerRepository {
  Future<EntryResponse> get(int page, int size);

  Future<EntryResponse> filter(int page, int size, Filter filter);

  Future<ApiMessage> create(Entry ledger);

  Future<ApiMessage> update(Entry ledger);

  Future<ApiMessage> delete(int? id);
}
