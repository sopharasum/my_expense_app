import 'package:expense_app/domain/entities/meta.dart';
import 'package:expense_app/domain/entities/plan.dart';

class TransactionResponse {
  final List<Transaction> data;
  final Meta meta;

  TransactionResponse({required this.data, required this.meta});

  factory TransactionResponse.fromJson(Map<String, dynamic> map) {
    return TransactionResponse(
      data: List<Transaction>.from(
        map["data"].map((x) => Transaction.fromJson(x)),
      ),
      meta: Meta.fromJson(map["meta"]),
    );
  }
}

class Transaction {
  final int transactionId;
  final Plan transactionPlan;
  final double transactionPrice;
  final String transactionStart;
  final String transactionEnd;
  final String transactionType;
  String transactionStatus;
  final String transactionCreate;

  Transaction({
    required this.transactionId,
    required this.transactionPlan,
    required this.transactionPrice,
    required this.transactionStart,
    required this.transactionEnd,
    required this.transactionType,
    required this.transactionStatus,
    required this.transactionCreate,
  });

  factory Transaction.fromJson(Map<String, dynamic> map) {
    return Transaction(
      transactionId: map["id"],
      transactionPlan: Plan.fromJson(map["plan"]),
      transactionPrice: map["price"].toDouble(),
      transactionStart: map["startDate"],
      transactionEnd: map["endDate"],
      transactionType: map["type"],
      transactionStatus: map["status"],
      transactionCreate: map["createdAt"],
    );
  }
}
