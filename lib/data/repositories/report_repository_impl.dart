import 'package:expense_app/data/data_sources/remote/api/report_api.dart';
import 'package:expense_app/domain/entities/report.dart';
import 'package:expense_app/domain/repositories/report_repository.dart';

class ReportRepositoryImpl extends ReportRepository {
  final ReportApi _api;

  ReportRepositoryImpl({
    required ReportApi api,
  }) : _api = api;

  @override
  Future<ReportResponse> monthly(String start, String end) async {
    return await _api.monthly(start, end);
  }

  @override
  Future<ReportDateRangeResponse> dateRange(
    String type,
    String start,
    String end,
  ) async {
    return await _api.dateRange(type, start, end);
  }

  @override
  Future<ReportYearlyResponse> yearly(String start, String end) async {
    return await _api.yearly(start, end);
  }
}
