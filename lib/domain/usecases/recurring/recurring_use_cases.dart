import 'package:expense_app/domain/usecases/recurring/add_recurring_use_case.dart';
import 'package:expense_app/domain/usecases/recurring/delete_recurring_use_case.dart';
import 'package:expense_app/domain/usecases/recurring/get_recurring_use_case.dart';
import 'package:expense_app/domain/usecases/recurring/update_recurring_use_case.dart';

class RecurringUseCases {
  final GetRecurringUseCase getUseCase;
  final AddRecurringUseCase addUseCase;
  final UpdateRecurringUseCase updateUseCase;
  final DeleteRecurringUseCase deleteUseCase;

  RecurringUseCases({
    required this.getUseCase,
    required this.addUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
  });
}
