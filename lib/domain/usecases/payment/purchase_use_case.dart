import 'package:expense_app/config/formatter.dart';
import 'package:expense_app/domain/entities/plan.dart';
import 'package:expense_app/domain/entities/purchase.dart';
import 'package:expense_app/domain/repositories/payment_repository.dart';

class PurchaseUseCase {
  final PaymentRepository _repository;

  PurchaseUseCase({
    required PaymentRepository repository,
  }) : _repository = repository;

  Future<PurchaseResponse> purchase(Plan plan) async {
    final purchase = Purchase(
        purchaseStart: Formatter.dateOnlyToString(DateTime.now()),
        purchaseEnd: Formatter.dateOnlyToString(
          DateTime.now().add(Duration(days: plan.numberOfDays)),
        ));
    return await _repository.purchase(purchase, plan);
  }
}
