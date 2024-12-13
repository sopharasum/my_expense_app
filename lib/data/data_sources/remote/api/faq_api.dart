import 'package:dio/dio.dart';
import 'package:expense_app/config/api/api_helper.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/faq.dart';
import 'package:get/instance_manager.dart';

class FaqApi {
  final ApiBaseHelper _apiBaseHelper = Get.find();

  Future<FaqResponse> get(int page, int size) async {
    final Response response = await _apiBaseHelper.getWithHeader(
      endPoint: apiUrl + "faq",
      body: {
        "page": page,
        "size": size,
      },
    );
    return FaqResponse.fromJson(response.data);
  }
}
