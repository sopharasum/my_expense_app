import 'package:dio/dio.dart';
import 'package:expense_app/config/api/api_helper.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/entry.dart';
import 'package:expense_app/domain/entities/filter.dart';
import 'package:get/instance_manager.dart';

class LedgerApi {
  final ApiBaseHelper _apiBaseHelper = Get.find();

  Future<EntryResponse> get(int page, int size) async {
    final Response response = await _apiBaseHelper.getWithHeader(
      endPoint: apiUrl + "ledger",
      body: {
        "page": page,
        "size": size,
      },
    );
    return EntryResponse.fromJson(response.data);
  }

  Future<EntryResponse> filter(int page, int size, Filter filter) async {
    final Response response = await _apiBaseHelper.postWithHeader(
      endPoint: apiUrl + "ledger/filter",
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

  Future<ApiMessage> create(Entry ledger) async {
    final Response response = await _apiBaseHelper.postWithHeader(
      endPoint: apiUrl + "ledger",
      data: {
        "categoryId": ledger.entryCategory?.categoryId,
        "amount": ledger.entryAmount,
        "currency": ledger.entryCurrency,
        "remark": ledger.entryRemark,
        "date": ledger.entryDateTime,
      },
    );
    return ApiMessage.fromJson(response.data);
  }

  Future<ApiMessage> update(Entry ledger) async {
    final Response response = await _apiBaseHelper.put(
      endPoint: apiUrl + "ledger/${ledger.entryId}",
      body: {
        "categoryId": ledger.entryCategory?.categoryId,
        "amount": ledger.entryAmount,
        "currency": ledger.entryCurrency,
        "remark": ledger.entryRemark,
        "date": ledger.entryDateTime,
      },
    );
    return ApiMessage.fromJson(response.data);
  }

  Future<ApiMessage> delete(int? id) async {
    final Response response = await _apiBaseHelper.delete(
      endPoint: apiUrl + "ledger/$id",
    );
    return ApiMessage.fromJson(response.data);
  }
}
