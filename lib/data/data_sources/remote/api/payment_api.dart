import 'package:dio/dio.dart';
import 'package:expense_app/config/api/api_helper.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/payment.dart';
import 'package:expense_app/domain/entities/plan.dart';
import 'package:expense_app/domain/entities/purchase.dart';
import 'package:expense_app/domain/entities/transaction.dart';
import 'package:get/instance_manager.dart';

class PaymentApi {
  final ApiBaseHelper _apiBaseHelper = Get.find();

  Future<PaymentResponse> getPayment() async {
    final Response response = await _apiBaseHelper.getWithHeader(
      endPoint: apiUrl + "payment",
    );
    return PaymentResponse.fromJson(response.data);
  }

  Future<PlanResponse> getPlan(int page, int size) async {
    final Response response = await _apiBaseHelper.getWithHeader(
      endPoint: apiUrl + "plan",
    );
    return PlanResponse.fromJson(response.data);
  }

  Future<TransactionResponse> transaction(int page, int size) async {
    final Response response = await _apiBaseHelper.getWithHeader(
      endPoint: apiUrl + "payment/transaction",
      body: {
        "page": page,
        "size": size,
      },
    );
    return TransactionResponse.fromJson(response.data);
  }

  Future<PurchaseResponse> purchase(Purchase purchase, Plan plan) async {
    final Response response = await _apiBaseHelper
        .postWithHeader(endPoint: apiUrl + "payment", data: {
      "accountantId": -1,
      "plan": plan.id,
      "price": plan.discount != null ? plan.discount : plan.price,
      "start": purchase.purchaseStart,
      "end": purchase.purchaseEnd,
      "type": "CASH",
      "status": "PENDING"
    });
    return PurchaseResponse.fromJson(response.data);
  }

  Future<PurchaseResponse> update(int? id, String status) async {
    final Response response = await _apiBaseHelper.put(
      endPoint: apiUrl + "payment/$id",
      body: {
        "status": status,
      },
    );
    return PurchaseResponse.fromJson(response.data);
  }
}
