import 'package:dio/dio.dart';
import 'package:expense_app/config/api/api_helper.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/report.dart';
import 'package:get/instance_manager.dart';

class ReportApi {
  final ApiBaseHelper _apiBaseHelper = Get.find();

  Future<ReportResponse> monthly(String start, String end) async {
    final Response response = await _apiBaseHelper.postWithHeader(
      endPoint: apiUrl + "report",
      data: {
        "start": start,
        "end": end,
      },
    );
    return ReportResponse.fromJson(response.data);
  }

  Future<ReportDateRangeResponse> dateRange(
    String type,
    String start,
    String end,
  ) async {
    final Response response = await _apiBaseHelper.postWithHeader(
      endPoint: apiUrl + "report/date-range",
      data: {
        "start": start,
        "end": end,
      },
      query: {
        "type": type,
      },
    );
    return ReportDateRangeResponse.fromJson(response.data);
  }

  Future<ReportYearlyResponse> yearly(String start, String end) async {
    final Response response = await _apiBaseHelper.postWithHeader(
      endPoint: apiUrl + "report/yearly",
      data: {
        "start": start,
        "end": end,
      },
    );
    return ReportYearlyResponse.fromJson(response.data);
  }
}
