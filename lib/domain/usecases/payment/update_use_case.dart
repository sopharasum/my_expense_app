import 'package:expense_app/domain/entities/purchase.dart';
import 'package:expense_app/domain/repositories/payment_repository.dart';

class UpdateStatusUseCase {
  final PaymentRepository _repository;

  UpdateStatusUseCase({
    required PaymentRepository repository,
  }) : _repository = repository;

  Future<PurchaseResponse> update(int? id) async {
    return await _repository.update(id, "CANCEL");
  }
}
