import 'package:expense_app/domain/entities/meta.dart';

class PlanResponse {
  final List<Plan> data;
  final Meta meta;

  PlanResponse({required this.data, required this.meta});

  factory PlanResponse.fromJson(Map<String, dynamic> map) {
    return PlanResponse(
      data: List<Plan>.from(map["data"].map((x) => Plan.fromJson(x))),
      meta: Meta.fromJson(map["meta"]),
    );
  }
}

class Plan {
  final int id;
  final String name;
  final double price;
  double? discount;
  String? description;
  final int numberOfDays;
  final bool status;

  Plan({
    required this.id,
    required this.name,
    required this.price,
    this.discount,
    this.description,
    required this.numberOfDays,
    required this.status,
  });

  factory Plan.fromJson(Map<String, dynamic> map) {
    return Plan(
      id: map["id"],
      name: map["name"],
      price: map["price"].toDouble(),
      discount: map["discount"] != null ? map["discount"].toDouble() : null,
      description: map["description"] != null ? map["description"] : null,
      numberOfDays: map["numberOfDays"],
      status: map["status"],
    );
  }
}
