import 'package:expense_app/data/data_sources/remote/api/faq_api.dart';
import 'package:expense_app/domain/entities/faq.dart';
import 'package:expense_app/domain/repositories/faq_repository.dart';

class FaqRepositoryImpl extends FaqRepository {
  final FaqApi _api;

  FaqRepositoryImpl({required FaqApi api}) : _api = api;

  @override
  Future<FaqResponse> get(int page, int size) async {
    return await _api.get(page, size);
  }
}
