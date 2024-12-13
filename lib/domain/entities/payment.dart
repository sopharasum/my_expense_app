class PaymentResponse {
  final Payment data;

  PaymentResponse({required this.data});

  factory PaymentResponse.fromJson(Map<String, dynamic> map) {
    return PaymentResponse(data: Payment.fromJson(map["data"]));
  }
}

class Payment {
  final String paymentName;
  final String paymentStatus;
  final String paymentStartDate;
  final String paymentEndDate;

  Payment({
    required this.paymentName,
    required this.paymentStatus,
    required this.paymentStartDate,
    required this.paymentEndDate,
  });

  factory Payment.fromJson(Map<String, dynamic> map) {
    return Payment(
      paymentName: map["name"],
      paymentStatus: map["status"],
      paymentStartDate: map["start"],
      paymentEndDate: map["end"],
    );
  }

  toJson() {
    return {
      "name": paymentName,
      "status": paymentStatus,
      "start": paymentStartDate,
      "end": paymentEndDate,
    };
  }
}
