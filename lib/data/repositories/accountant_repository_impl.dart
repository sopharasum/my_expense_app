import 'package:expense_app/data/data_sources/remote/api/accountant_api.dart';
import 'package:expense_app/domain/entities/accountant.dart';
import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/configuration.dart';
import 'package:expense_app/domain/repositories/accountant_repository.dart';

class AccountantRepositoryImpl extends AccountantRepository {
  final AccountantApi _api;

  AccountantRepositoryImpl({required AccountantApi api}) : _api = api;

  @override
  Future<AccountantResponse> login(String phoneNumber) async {
    return await _api.login(phoneNumber);
  }

  @override
  Future<ApiMessage> updateLastLogin() async {
    return await _api.updateLastLogin();
  }

  @override
  Future<AccountantResponse> regenerateToken(String? refreshToken) async {
    return await _api.regenerateToken(refreshToken);
  }

  @override
  Future<AccountantResponse> google(String? accessToken) async {
    return await _api.social(accessToken, "google");
  }

  @override
  Future<AccountantResponse> facebook(String? accessToken) async {
    return await _api.social(accessToken, "facebook");
  }

  @override
  Future<ConfigurationResponse> getConfiguration() async {
    return await _api.getConfiguration();
  }
}
