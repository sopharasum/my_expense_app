import 'package:expense_app/data/data_sources/remote/api/payment_api.dart';
import 'package:expense_app/domain/entities/payment.dart';
import 'package:expense_app/domain/entities/plan.dart';
import 'package:expense_app/domain/entities/purchase.dart';
import 'package:expense_app/domain/entities/transaction.dart';
import 'package:expense_app/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  final PaymentApi _api;

  PaymentRepositoryImpl({required PaymentApi api}) : _api = api;

  @override
  Future<PaymentResponse> getPayment() async {
    return await _api.getPayment();
  }

  @override
  Future<PlanResponse> getPlan(int page, int size) async {
    return await _api.getPlan(page, size);
  }

  @override
  Future<PurchaseResponse> purchase(Purchase purchase, Plan plan) async {
    return await _api.purchase(purchase, plan);
  }

  @override
  Future<TransactionResponse> transaction(int page, int size) async {
    return await _api.transaction(page, size);
  }

  @override
  Future<PurchaseResponse> update(int? id, String status) async {
    return await _api.update(id, status);
  }
}
