import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/regenerate_token.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/data/data_sources/preference/profile_pref.dart';
import 'package:expense_app/domain/entities/api_message.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiBaseHelper {
  static Dio _createDio() {
    return Dio()
      ..interceptors.add(PrettyDioLogger(
        error: true,
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        compact: true,
      ))
      ..options.connectTimeout = Duration(milliseconds: 60000)
      ..options.receiveTimeout = Duration(milliseconds: 60000)
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..options.headers = {"Accept": "application/json"};
  }

  static Dio _addInterceptorsWithHeader(Dio dio) {
    return dio
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => requestInterceptor(options, handler),
        ),
      );
  }

  static dynamic requestInterceptor(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await getLoggedAccount().then((accountant) async {
      await getLanguage().then((language) {
        options.headers.addAll({
          "Authorization": "Bearer ${accountant?.accountantToken}",
          "Accept-Language": language,
        });
      });
    });

    return handler.next(options);
  }

  static Dio _addInterceptorsNoHeader(Dio dio) {
    return dio
      ..interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) => handler.next(options),
          onResponse: (response, handler) => handler.next(response),
          onError: (e, handler) => handler.next(e)));
  }

  final _apiBaseWithHeader = _addInterceptorsWithHeader(_createDio());
  final _apiBaseNoHeader = _addInterceptorsNoHeader(_createDio());

  Future getWithHeader({
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      Response response = await _apiBaseWithHeader.get(
        endPoint,
        queryParameters: body,
      );
      return response;
    } on DioError catch (e) {
      return _onHandleDioError(e);
    } catch (e) {
      return throw ApiError(ApiErrorType.ERROR_REQUEST, null);
    }
  }

  Future postWithHeader({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? query,
  }) async {
    try {
      Response response = await _apiBaseWithHeader.post(
        endPoint,
        data: data,
        queryParameters: query,
      );
      return response;
    } on DioError catch (e) {
      return _onHandleDioError(e);
    } catch (e) {
      return throw ApiError(ApiErrorType.ERROR_REQUEST, null);
    }
  }

  Future getNoHeader(String endPoint, Map<String, dynamic> body) async {
    try {
      Response response = await _apiBaseNoHeader.get(
        endPoint,
        queryParameters: body,
      );
      return response;
    } on DioError catch (e) {
      return _onHandleDioError(e);
    } catch (e) {
      return throw ApiError(ApiErrorType.ERROR_REQUEST, null);
    }
  }

  Future postNoHeader({
    required String endPoint,
    required Map<String, dynamic> body,
  }) async {
    try {
      Response response = await _apiBaseNoHeader.post(endPoint, data: body);
      return response;
    } on DioError catch (e) {
      return _onHandleDioError(e);
    } catch (e) {
      return throw ApiError(ApiErrorType.ERROR_REQUEST, null);
    }
  }

  Future delete({required String endPoint, Map<String, dynamic>? body}) async {
    try {
      Response response = await _apiBaseWithHeader.delete(endPoint, data: body);
      return response;
    } on DioError catch (e) {
      return _onHandleDioError(e);
    } catch (e) {
      return throw ApiError(ApiErrorType.ERROR_REQUEST, null);
    }
  }

  Future put({required String endPoint, Map<String, dynamic>? body}) async {
    try {
      Response response = await _apiBaseWithHeader.put(endPoint, data: body);
      return response;
    } on DioException catch (e) {
      return _onHandleDioError(e);
    } catch (e) {
      return throw ApiError(ApiErrorType.ERROR_REQUEST, null);
    }
  }

  /// to handle error base on dio error
  Future<ApiError> _onHandleDioError(DioException exc) async {
    final apiMessage = ApiMessage.fromJson(
      exc.response != null ? exc.response?.data : null,
    );
    if (exc.error is SocketException) {
      return throw ApiError(ApiErrorType.NO_INTERNET, apiMessage);
    } else {
      switch (exc.type) {
        case DioExceptionType.cancel:
          break;
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.badResponse:
          if (apiMessage.code == 401) {
            await regenerateToken().then((isSuccess) {
              if (isSuccess) {
                return throw ApiError(ApiErrorType.EXPIRE_TOKEN, apiMessage);
              }
            });
          } else {
            return throw ApiError(ApiErrorType.ERROR_REQUEST, apiMessage);
          }
          break;
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.badCertificate:
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        return throw ApiError(ApiErrorType.ERROR_REQUEST, apiMessage);
      }
    }
    return throw ApiError(ApiErrorType.ERROR_REQUEST, apiMessage);
  }
}
