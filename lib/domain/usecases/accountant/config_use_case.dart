import 'package:expense_app/domain/entities/configuration.dart';
import 'package:expense_app/domain/repositories/accountant_repository.dart';

class ConfigurationUseCase {
  final AccountantRepository _repository;

  ConfigurationUseCase({
    required AccountantRepository repository,
  }) : _repository = repository;

  Future<ConfigurationResponse> get() async {
    return await _repository.getConfiguration();
  }
}
