import 'package:dio/dio.dart';
import 'package:expense_app/config/api/api_helper.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/recurring.dart';
import 'package:get/instance_manager.dart';

class RecurringApi {
  final ApiBaseHelper _apiBaseHelper = Get.find();

  Future<RecurringResponse> get(int page, int size) async {
    final Response response = await _apiBaseHelper.getWithHeader(
      endPoint: apiUrl + "recurring",
      body: {
        "page": page,
        "size": size,
      },
    );
    return RecurringResponse.fromJson(response.data);
  }

  Future<ApiMessage> create(Recurring recurring) async {
    final Response response = await _apiBaseHelper.postWithHeader(
      endPoint: apiUrl + "recurring",
      data: recurring.toJson(),
    );
    return ApiMessage.fromJson(response.data);
  }

  Future<ApiMessage> update(Recurring recurring) async {
    final Response response = await _apiBaseHelper.put(
      endPoint: apiUrl + "recurring/${recurring.recurringId}",
      body: recurring.toJson(),
    );
    return ApiMessage.fromJson(response.data);
  }

  Future<ApiMessage> delete(int? id) async {
    final Response response = await _apiBaseHelper.delete(
      endPoint: apiUrl + "recurring/$id",
    );
    return ApiMessage.fromJson(response.data);
  }
}
