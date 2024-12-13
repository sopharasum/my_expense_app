import 'package:expense_app/domain/entities/payment.dart';
import 'package:expense_app/domain/entities/plan.dart';
import 'package:expense_app/domain/entities/purchase.dart';
import 'package:expense_app/domain/entities/transaction.dart';

abstract class PaymentRepository {
  Future<PaymentResponse> getPayment();

  Future<PlanResponse> getPlan(int page, int size);

  Future<TransactionResponse> transaction(int page, int size);

  Future<PurchaseResponse> purchase(Purchase purchase, Plan plan);

  Future<PurchaseResponse> update(int? id, String status);
}
