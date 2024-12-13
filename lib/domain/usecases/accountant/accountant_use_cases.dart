import 'package:expense_app/domain/usecases/accountant/config_use_case.dart';
import 'package:expense_app/domain/usecases/accountant/login_use_case.dart';
import 'package:expense_app/domain/usecases/accountant/regenerate_token_use_case.dart';
import 'package:expense_app/domain/usecases/accountant/social_use_case.dart';
import 'package:expense_app/domain/usecases/accountant/update_last_login_use_case.dart';

class AccountantUseCases {
  ConfigurationUseCase configurationUseCase;
  LoginUseCase loginUseCase;
  SocialUseCase socialUseCase;
  UpdateLastLoginUseCase updateLastLoginUseCase;
  RegenerateTokenUseCase regenerateTokenUseCase;

  AccountantUseCases({
    required this.configurationUseCase,
    required this.loginUseCase,
    required this.socialUseCase,
    required this.updateLastLoginUseCase,
    required this.regenerateTokenUseCase,
  });
}
