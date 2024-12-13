import 'package:expense_app/domain/entities/accountant.dart';
import 'package:expense_app/domain/repositories/accountant_repository.dart';

class LoginUseCase {
  final AccountantRepository _repository;

  LoginUseCase({
    required AccountantRepository repository,
  }) : _repository = repository;

  Future<AccountantResponse> login(String phoneNumber) async {
    return await _repository.login(phoneNumber);
  }

  Future<AccountantResponse> google(String? accessToken) async {
    return await _repository.google(accessToken);
  }

  Future<AccountantResponse> facebook(String? accessToken) async {
    return await _repository.facebook(accessToken);
  }
}
