import 'package:expense_app/domain/repositories/accountant_repository.dart';

class UpdateLastLoginUseCase {
  final AccountantRepository _repository;

  UpdateLastLoginUseCase({
    required AccountantRepository repository,
  }) : _repository = repository;

  Future<void> update() async {
    await _repository.updateLastLogin();
  }
}
