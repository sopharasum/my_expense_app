class PurchaseResponse {
  final Purchase data;

  PurchaseResponse({required this.data});

  factory PurchaseResponse.fromJson(Map<String, dynamic> map) {
    return PurchaseResponse(data: Purchase.fromJson(map["data"]));
  }
}

class Purchase {
  final int? purchaseId;
  final double? purchasePrice;
  String? purchaseStart;
  String? purchaseEnd;
  final String? purchaseStatus;

  Purchase({
    this.purchaseId,
    this.purchasePrice,
    this.purchaseStart,
    this.purchaseEnd,
    this.purchaseStatus,
  });

  factory Purchase.fromJson(Map<String, dynamic> map) {
    return Purchase(
      purchaseId: map["id"],
      purchasePrice: map["price"].toDouble(),
      purchaseStart: map["startDate"],
      purchaseEnd: map["endDate"],
      purchaseStatus: map["status"],
    );
  }
}
