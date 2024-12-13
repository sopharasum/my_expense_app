import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/domain/entities/api_message.dart';

class ApiError {
  final ApiErrorType apiErrorType;
  final ApiMessage? apiMessage;

  ApiError(this.apiErrorType, this.apiMessage);
}