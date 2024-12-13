import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/report.dart';
import 'package:expense_app/domain/repositories/report_repository.dart';

class GetUseCase {
  final ReportRepository _repository;

  GetUseCase({
    required ReportRepository repository,
  }) : _repository = repository;

  Future<ReportData> get(String start, String end) async {
    final response = await _repository.monthly(start, end);
    return response.data;
  }

  Future<ReportYearlyData> yearly(String start, String end) async {
    final response = await _repository.yearly(start, end);
    return response.data;
  }

  Future<List<Entry>> dateRange(String type, String start, String end) async {
    final response = await _repository.dateRange(type, start, end);
    return response.data;
  }
}
