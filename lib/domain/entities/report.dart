import 'package:expense_app/domain/entities/entry.dart';

class ReportResponse {
  final ReportData data;

  ReportResponse({required this.data});

  factory ReportResponse.fromJson(Map<String, dynamic> map) {
    return ReportResponse(data: ReportData.fromJson(map["data"]));
  }
}

class ReportData {
  final Report report;
  final Summary summary;

  ReportData({required this.report, required this.summary});

  factory ReportData.fromJson(Map<String, dynamic> map) {
    return ReportData(
      report: Report.fromJson(map["report"]),
      summary: Summary.fromJson(map["summary"]),
    );
  }
}

class Report {
  final List<ReportCategory> ledgers;
  final List<ReportCategory> incomes;

  Report({required this.ledgers, required this.incomes});

  factory Report.fromJson(Map<String, dynamic> map) {
    return Report(
      ledgers: List<ReportCategory>.from(
          map["ledgers"].map((x) => ReportCategory.fromJson(x))),
      incomes: List<ReportCategory>.from(
          map["incomes"].map((x) => ReportCategory.fromJson(x))),
    );
  }
}

class Summary {
  final Amount subtotalLedger;
  final Amount subtotalIncome;
  final Amount totalLedger;
  final Amount totalIncome;
  final Amount balance;

  Summary({
    required this.subtotalLedger,
    required this.subtotalIncome,
    required this.totalLedger,
    required this.totalIncome,
    required this.balance,
  });

  factory Summary.fromJson(Map<String, dynamic> map) {
    return Summary(
      subtotalLedger: Amount.fromJson(map["subtotalLedger"]),
      subtotalIncome: Amount.fromJson(map["subtotalIncome"]),
      totalLedger: Amount.fromJson(map["totalLedger"]),
      totalIncome: Amount.fromJson(map["totalIncome"]),
      balance: Amount.fromJson(map["balance"]),
    );
  }
}

class ReportCategory {
  final int id;
  final String name;
  final double khAmount;
  final double usAmount;

  ReportCategory({
    required this.id,
    required this.name,
    required this.khAmount,
    required this.usAmount,
  });

  factory ReportCategory.fromJson(Map<String, dynamic> map) {
    return ReportCategory(
      id: map["id"],
      name: map["name"],
      khAmount: map["khAmount"].toDouble(),
      usAmount: map["usAmount"].toDouble(),
    );
  }
}

class Amount {
  final double khAmount;
  final double usAmount;

  Amount({required this.khAmount, required this.usAmount});

  factory Amount.fromJson(Map<String, dynamic> map) {
    return Amount(
      khAmount: map["khAmount"].toDouble(),
      usAmount: map["usAmount"].toDouble(),
    );
  }
}

class ReportDateRangeResponse {
  final List<Entry> data;

  ReportDateRangeResponse({required this.data});

  factory ReportDateRangeResponse.fromJson(Map<String, dynamic> map) {
    return ReportDateRangeResponse(
      data: List<Entry>.from(map["data"].map((x) => Entry.fromJson(x))),
    );
  }
}

class ReportYearlyResponse {
  final ReportYearlyData data;

  ReportYearlyResponse({required this.data});

  factory ReportYearlyResponse.fromJson(Map<String, dynamic> map) {
    return ReportYearlyResponse(data: ReportYearlyData.fromJson(map["data"]));
  }
}

class ReportYearlyData {
  final ReportYearly report;
  final Summary summary;

  ReportYearlyData({required this.report, required this.summary});

  factory ReportYearlyData.fromJson(Map<String, dynamic> map) {
    return ReportYearlyData(
      report: ReportYearly.fromJson(map["report"]),
      summary: Summary.fromJson(map["summary"]),
    );
  }
}

class ReportYearly {
  final List<ReportMonth> ledgers;
  final List<ReportMonth> incomes;

  ReportYearly({required this.ledgers, required this.incomes});

  factory ReportYearly.fromJson(Map<String, dynamic> map) {
    return ReportYearly(
      ledgers: List<ReportMonth>.from(
          map["ledgers"].map((item) => ReportMonth.fromJson(item))),
      incomes: List<ReportMonth>.from(
          map["incomes"].map((item) => ReportMonth.fromJson(item))),
    );
  }
}

class ReportMonth {
  final String month;
  final double khAmount;
  final double usAmount;

  ReportMonth({
    required this.month,
    required this.khAmount,
    required this.usAmount,
  });

  factory ReportMonth.fromJson(Map<String, dynamic> map) {
    return ReportMonth(
      month: map["month"],
      khAmount: map["khAmount"],
      usAmount: map["usAmount"],
    );
  }
}
