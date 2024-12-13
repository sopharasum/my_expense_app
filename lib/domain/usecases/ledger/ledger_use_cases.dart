import 'package:expense_app/domain/usecases/ledger/add_ledger_use_case.dart';
import 'package:expense_app/domain/usecases/ledger/delete_ledger_use_case.dart';
import 'package:expense_app/domain/usecases/ledger/get_ledger_use_case.dart';
import 'package:expense_app/domain/usecases/ledger/update_ledger_use_case.dart';

class LedgerUseCases {
  GetLedgerUseCase getUseCase;
  AddLedgerUseCase addUseCase;
  UpdateLedgerUseCase updateUseCase;
  DeleteLedgerUseCase deleteUseCase;

  LedgerUseCases({
    required this.getUseCase,
    required this.addUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
  });
}
