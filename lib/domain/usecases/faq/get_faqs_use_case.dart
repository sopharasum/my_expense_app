import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/faq.dart';
import 'package:expense_app/domain/repositories/faq_repository.dart';

class GetFaqsUseCase {
  final FaqRepository _repository;

  GetFaqsUseCase({
    required FaqRepository repository,
  }) : _repository = repository;

  Future<FaqResponse> get(int page) async {
    return await _repository.get(page, defaultSize);
  }
}
