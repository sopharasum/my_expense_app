import 'package:dio/dio.dart';
import 'package:expense_app/config/api/api_helper.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/accountant.dart';
import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/configuration.dart';
import 'package:get/instance_manager.dart';

class AccountantApi {
  final ApiBaseHelper _apiBaseHelper = Get.find();

  Future<AccountantResponse> login(String phoneNumber) async {
    final Response response = await _apiBaseHelper.postNoHeader(
      endPoint: apiUrl + "accountant",
      body: {
        "phoneNumber": phoneNumber,
      },
    );
    return AccountantResponse.fromJson(response.data);
  }

  Future<AccountantResponse> social(
      String? accessToken, String endPoint) async {
    final Response response = await _apiBaseHelper.postNoHeader(
      endPoint: apiUrl + "accountant/$endPoint",
      body: {
        "accessToken": accessToken,
      },
    );
    return AccountantResponse.fromJson(response.data);
  }

  Future<ApiMessage> updateLastLogin() async {
    final Response response = await _apiBaseHelper.put(
      endPoint: apiUrl + "accountant",
    );
    return ApiMessage.fromJson(response.data);
  }

  Future<AccountantResponse> regenerateToken(String? refreshToken) async {
    final Response response = await _apiBaseHelper.postNoHeader(
      endPoint: apiUrl + "accountant/regenerate-token",
      body: {
        "token": refreshToken,
      },
    );
    return AccountantResponse.fromJson(response.data);
  }

  Future<ConfigurationResponse> getConfiguration() async {
    final Response response = await _apiBaseHelper.getWithHeader(
      endPoint: apiUrl + "configuration",
    );
    return ConfigurationResponse.fromJson(response.data);
  }
}
