import 'package:dio/dio.dart';
import 'package:expense_app/config/api/api_helper.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/category.dart';
import 'package:get/instance_manager.dart';

class CategoryApi {
  final ApiBaseHelper _apiBaseHelper = Get.find();

  Future<CategoryResponse> get(String? type) async {
    final Response response = await _apiBaseHelper.getWithHeader(
      endPoint: apiUrl + "category",
      body: type != null ? {"type": type} : null,
    );
    return CategoryResponse.fromJson(response.data);
  }

  Future<ApiMessage> create(Category category) async {
    final Response response = await _apiBaseHelper.postWithHeader(
      endPoint: apiUrl + "category",
      data: {
        "name": category.categoryName,
        "type": category.categoryType,
      },
    );
    return ApiMessage.fromJson(response.data);
  }

  Future<ApiMessage> update(Category category) async {
    final Response response = await _apiBaseHelper.put(
      endPoint: apiUrl + "category/${category.categoryId}",
      body: {
        "name": category.categoryName,
        "type": category.categoryType,
      },
    );
    return ApiMessage.fromJson(response.data);
  }

  Future<ApiMessage> delete(int? id) async {
    final Response response = await _apiBaseHelper.delete(
      endPoint: apiUrl + "category/$id",
    );
    return ApiMessage.fromJson(response.data);
  }
}
