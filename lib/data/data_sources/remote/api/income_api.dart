import 'package:dio/dio.dart';
import 'package:expense_app/config/api/api_helper.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/filter.dart';
import 'package:get/instance_manager.dart';

class IncomeApi {
  final ApiBaseHelper _apiBaseHelper = Get.find();

  Future<EntryResponse> get(int page, int size) async {
    final Response response = await _apiBaseHelper.getWithHeader(
      endPoint: apiUrl + "income",
      body: {
        "page": page,
        "size": size,
      },
    );
    return EntryResponse.fromJson(response.data);
  }

  Future<EntryResponse> filter(int page, int size, Filter filter) async {
    final Response response = await _apiBaseHelper.postWithHeader(
      endPoint: apiUrl + "income/filter",
      data: {
        "categoryId": filter.categoryId,
        "from": filter.startDate,
        "to": filter.endDate,
      },
      query: {
        "page": page,
        "size": size,
      },
    );
    return EntryResponse.fromJson(response.data);
  }

  Future<ApiMessage> create(Entry income) async {
    final Response response = await _apiBaseHelper.postWithHeader(
      endPoint: apiUrl + "income",
      data: {
        "categoryId": income.entryCategory?.categoryId,
        "amount": income.entryAmount,
        "currency": income.entryCurrency,
        "remark": income.entryRemark,
        "date": income.entryDateTime,
      },
    );
    return ApiMessage.fromJson(response.data);
  }

  Future<ApiMessage> update(Entry income) async {
    final Response response = await _apiBaseHelper.put(
      endPoint: apiUrl + "income/${income.entryId}",
      body: {
        "categoryId": income.entryCategory?.categoryId,
        "amount": income.entryAmount,
        "currency": income.entryCurrency,
        "remark": income.entryRemark,
        "date": income.entryDateTime,
      },
    );
    return ApiMessage.fromJson(response.data);
  }

  Future<ApiMessage> delete(int? id) async {
    final Response response = await _apiBaseHelper.delete(
      endPoint: apiUrl + "income/$id",
    );
    return ApiMessage.fromJson(response.data);
  }
}
