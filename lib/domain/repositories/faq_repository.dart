import 'package:expense_app/domain/entities/faq.dart';

abstract class FaqRepository {
  Future<FaqResponse> get(int page, int size);
}