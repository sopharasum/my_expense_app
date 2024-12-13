import 'package:expense_app/domain/usecases/payment/get_use_case.dart';
import 'package:expense_app/domain/usecases/payment/purchase_use_case.dart';
import 'package:expense_app/domain/usecases/payment/update_use_case.dart';

class PaymentUseCases {
  PaymentGetUseCase getUseCase;
  PurchaseUseCase purchaseUseCase;
  UpdateStatusUseCase updateStatusUseCase;

  PaymentUseCases({
    required this.getUseCase,
    required this.purchaseUseCase,
    required this.updateStatusUseCase,
  });
}
