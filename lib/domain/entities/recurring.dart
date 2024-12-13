import 'package:expense_app/domain/entities/category.dart';
import 'package:expense_app/domain/entities/day_of_week.dart';
import 'package:expense_app/domain/entities/meta.dart';

class RecurringResponse {
  final List<Recurring> data;
  final Meta meta;

  RecurringResponse({required this.data, required this.meta});

  factory RecurringResponse.fromJson(Map<String, dynamic> map) {
    return RecurringResponse(
      data: List<Recurring>.from(map["data"].map((x) => Recurring.fromJson(x))),
      meta: Meta.fromJson(map["meta"]),
    );
  }
}

class Recurring {
  final int? recurringId;
  final Category? category;
  final double recurringAmount;
  final String recurringCurrency;
  final String recurringRemark;
  final String? recurringDate;
  final String recurringTime;
  final List<DayOfWeek> dayOfWeek;
  final String? recurringCreatedDate;

  Recurring({
    this.recurringId,
    required this.category,
    required this.recurringAmount,
    required this.recurringCurrency,
    required this.recurringRemark,
    this.recurringDate,
    required this.recurringTime,
    required this.dayOfWeek,
    this.recurringCreatedDate,
  });

  factory Recurring.fromJson(Map<String, dynamic> map) {
    return Recurring(
      recurringId: map["id"],
      category: Category.fromJson(map["category"]),
      recurringAmount: map["amount"].toDouble(),
      recurringCurrency: map["currency"],
      recurringRemark: map["remark"],
      recurringDate: map["date"],
      recurringTime: map["time"],
      dayOfWeek: List<DayOfWeek>.from(
        map["days"].map((x) => DayOfWeek.fromJson(x)),
      ),
      recurringCreatedDate: map["createdAt"],
    );
  }

  toJson() {
    return {
      "categoryId": category?.categoryId,
      "amount": recurringAmount,
      "currency": recurringCurrency,
      "remark": recurringRemark,
      "time": recurringTime,
      "monday": dayOfWeek[0].selected,
      "tuesday": dayOfWeek[1].selected,
      "wednesday": dayOfWeek[2].selected,
      "thursday": dayOfWeek[3].selected,
      "friday": dayOfWeek[4].selected,
      "saturday": dayOfWeek[5].selected,
      "sunday": dayOfWeek[6].selected,
    };
  }
}
