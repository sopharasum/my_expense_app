import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/recurring.dart';

abstract class RecurringRepository {
  Future<RecurringResponse> get(int page, int size);

  Future<ApiMessage> create(Recurring recurring);

  Future<ApiMessage> update(Recurring recurring);

  Future<ApiMessage> delete(int? id);
}
