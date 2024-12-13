import 'package:expense_app/data/data_sources/remote/api/recurring_api.dart';
import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/recurring.dart';
import 'package:expense_app/domain/repositories/recurring_repository.dart';

class RecurringRepositoryImpl extends RecurringRepository {
  final RecurringApi _api;

  RecurringRepositoryImpl({required RecurringApi api}) : _api = api;

  @override
  Future<RecurringResponse> get(int page, int size) async {
    return await _api.get(page, size);
  }

  @override
  Future<ApiMessage> create(Recurring recurring) async {
    return await _api.create(recurring);
  }

  @override
  Future<ApiMessage> update(Recurring recurring) async {
    return await _api.update(recurring);
  }

  @override
  Future<ApiMessage> delete(int? id) async {
    return await _api.delete(id);
  }
}
