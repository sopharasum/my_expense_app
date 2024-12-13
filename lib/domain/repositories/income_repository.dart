import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/filter.dart';

abstract class IncomeRepository {
  Future<EntryResponse> get(int page, int size);

  Future<EntryResponse> filter(int page, int size, Filter filter);

  Future<ApiMessage> create(Entry income);

  Future<ApiMessage> update(Entry income);

  Future<ApiMessage> delete(int? id);
}
