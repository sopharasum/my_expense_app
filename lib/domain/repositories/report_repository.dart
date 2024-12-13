import 'package:expense_app/domain/entities/report.dart';

abstract class ReportRepository {
  Future<ReportResponse> monthly(String start, String end);

  Future<ReportYearlyResponse> yearly(String start, String end);

  Future<ReportDateRangeResponse> dateRange(
    String type,
    String start,
    String end,
  );
}
