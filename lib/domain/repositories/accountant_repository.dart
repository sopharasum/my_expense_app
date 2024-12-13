import 'package:expense_app/domain/entities/accountant.dart';
import 'package:expense_app/domain/entities/api_message.dart';
import 'package:expense_app/domain/entities/configuration.dart';

abstract class AccountantRepository {
  Future<AccountantResponse> login(String phoneNumber);

  Future<ApiMessage> updateLastLogin();

  Future<AccountantResponse> regenerateToken(String? refreshToken);

  Future<AccountantResponse> google(String? accessToken);

  Future<AccountantResponse> facebook(String? accessToken);

  Future<ConfigurationResponse> getConfiguration();
}
