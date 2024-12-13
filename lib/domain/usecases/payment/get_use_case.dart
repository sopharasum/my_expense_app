import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/payment.dart';
import 'package:expense_app/domain/entities/plan.dart';
import 'package:expense_app/domain/entities/transaction.dart';
import 'package:expense_app/domain/repositories/payment_repository.dart';

class PaymentGetUseCase {
  final PaymentRepository _repository;

  PaymentGetUseCase({
    required PaymentRepository repository,
  }) : _repository = repository;

  Future<PaymentResponse> status() async {
    return await _repository.getPayment();
  }

  Future<PlanResponse> plan(int page) async {
    return await _repository.getPlan(page, defaultSize);
  }

  Future<TransactionResponse> transaction(int page) async {
    return await _repository.transaction(page, defaultSize);
  }
}
