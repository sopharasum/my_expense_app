import 'package:expense_app/data/data_sources/preference/profile_pref.dart';
import 'package:expense_app/domain/entities/accountant.dart';
import 'package:expense_app/domain/repositories/accountant_repository.dart';

class RegenerateTokenUseCase {
  final AccountantRepository _repository;

  RegenerateTokenUseCase({
    required AccountantRepository repository,
  }) : _repository = repository;

  Future<AccountantResponse> regenerate() async {
    final accountant = await getLoggedAccount();
    final response = await _repository.regenerateToken(
      accountant?.accountantRefreshToken,
    );
    return response;
  }
}
