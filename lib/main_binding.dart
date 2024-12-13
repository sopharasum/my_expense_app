import 'package:expense_app/config/api/api_helper.dart';
import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/data/data_sources/remote/api/accountant_api.dart';
import 'package:expense_app/data/data_sources/remote/api/category_api.dart';
import 'package:expense_app/data/data_sources/remote/api/faq_api.dart';
import 'package:expense_app/data/data_sources/remote/api/income_api.dart';
import 'package:expense_app/data/data_sources/remote/api/ledger_api.dart';
import 'package:expense_app/data/data_sources/remote/api/payment_api.dart';
import 'package:expense_app/data/data_sources/remote/api/recurring_api.dart';
import 'package:expense_app/data/data_sources/remote/api/report_api.dart';
import 'package:expense_app/data/repositories/accountant_repository_impl.dart';
import 'package:expense_app/data/repositories/category_repository_impl.dart';
import 'package:expense_app/data/repositories/faq_repository_impl.dart';
import 'package:expense_app/data/repositories/income_repository_impl.dart';
import 'package:expense_app/data/repositories/ledger_repository_impl.dart';
import 'package:expense_app/data/repositories/payment_repository_impl.dart';
import 'package:expense_app/data/repositories/recurring_repository_impl.dart';
import 'package:expense_app/data/repositories/report_repository_impl.dart';
import 'package:expense_app/domain/repositories/accountant_repository.dart';
import 'package:expense_app/domain/repositories/category_repository.dart';
import 'package:expense_app/domain/repositories/faq_repository.dart';
import 'package:expense_app/domain/repositories/income_repository.dart';
import 'package:expense_app/domain/repositories/ledger_repository.dart';
import 'package:expense_app/domain/repositories/payment_repository.dart';
import 'package:expense_app/domain/repositories/recurring_repository.dart';
import 'package:expense_app/domain/repositories/report_repository.dart';
import 'package:expense_app/domain/usecases/accountant/accountant_use_cases.dart';
import 'package:expense_app/domain/usecases/accountant/config_use_case.dart';
import 'package:expense_app/domain/usecases/accountant/login_use_case.dart';
import 'package:expense_app/domain/usecases/accountant/regenerate_token_use_case.dart';
import 'package:expense_app/domain/usecases/accountant/social_use_case.dart';
import 'package:expense_app/domain/usecases/accountant/update_last_login_use_case.dart';
import 'package:expense_app/domain/usecases/category/add_category_use_case.dart';
import 'package:expense_app/domain/usecases/category/category_use_cases.dart';
import 'package:expense_app/domain/usecases/category/delete_category_use_case.dart';
import 'package:expense_app/domain/usecases/category/get_categories_use_case.dart';
import 'package:expense_app/domain/usecases/category/update_category_use_case.dart';
import 'package:expense_app/domain/usecases/faq/faq_use_cases.dart';
import 'package:expense_app/domain/usecases/faq/get_faqs_use_case.dart';
import 'package:expense_app/domain/usecases/income/add_income_use_case.dart';
import 'package:expense_app/domain/usecases/income/delete_income_use_case.dart';
import 'package:expense_app/domain/usecases/income/get_income_use_case.dart';
import 'package:expense_app/domain/usecases/income/income_use_cases.dart';
import 'package:expense_app/domain/usecases/income/update_income_use_case.dart';
import 'package:expense_app/domain/usecases/ledger/add_ledger_use_case.dart';
import 'package:expense_app/domain/usecases/ledger/delete_ledger_use_case.dart';
import 'package:expense_app/domain/usecases/ledger/get_ledger_use_case.dart';
import 'package:expense_app/domain/usecases/ledger/ledger_use_cases.dart';
import 'package:expense_app/domain/usecases/ledger/update_ledger_use_case.dart';
import 'package:expense_app/domain/usecases/payment/get_use_case.dart';
import 'package:expense_app/domain/usecases/payment/payment_use_cases.dart';
import 'package:expense_app/domain/usecases/payment/purchase_use_case.dart';
import 'package:expense_app/domain/usecases/payment/update_use_case.dart';
import 'package:expense_app/domain/usecases/recurring/add_recurring_use_case.dart';
import 'package:expense_app/domain/usecases/recurring/delete_recurring_use_case.dart';
import 'package:expense_app/domain/usecases/recurring/get_recurring_use_case.dart';
import 'package:expense_app/domain/usecases/recurring/recurring_use_cases.dart';
import 'package:expense_app/domain/usecases/recurring/update_recurring_use_case.dart';
import 'package:expense_app/domain/usecases/report/get_use_case.dart';
import 'package:expense_app/domain/usecases/report/report_use_cases.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    /** START INJECT HELPER */
    Get.lazyPut(() => ApiBaseHelper());
    Get.lazyPut(() => MaterialLoading());
    Get.lazyPut(() => ThemeService());
    /** END INJECT HELPER */

    /** START INJECT API DEPENDENCY */
    Get.lazyPut(() => AccountantApi());
    Get.lazyPut(() => CategoryApi());
    Get.lazyPut(() => LedgerApi());
    Get.lazyPut(() => IncomeApi());
    Get.lazyPut(() => ReportApi());
    Get.lazyPut(() => PaymentApi());
    Get.lazyPut(() => RecurringApi());
    Get.lazyPut(() => FaqApi());
    /** END INJECT API DEPENDENCY */

    /** START INJECT REPOSITORY DEPENDENCY */
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepositoryImpl(api: Get.find()),
    );
    Get.lazyPut<LedgerRepository>(
      () => LedgerRepositoryImpl(api: Get.find()),
    );
    Get.lazyPut<IncomeRepository>(
      () => IncomeRepositoryImpl(api: Get.find()),
    );
    Get.lazyPut<AccountantRepository>(
      () => AccountantRepositoryImpl(api: Get.find()),
    );
    Get.lazyPut<ReportRepository>(
      () => ReportRepositoryImpl(api: Get.find()),
    );
    Get.lazyPut<PaymentRepository>(
      () => PaymentRepositoryImpl(api: Get.find()),
    );
    Get.lazyPut<RecurringRepository>(
      () => RecurringRepositoryImpl(api: Get.find()),
    );
    Get.lazyPut<FaqRepository>(
          () => FaqRepositoryImpl(api: Get.find()),
    );
    /** END INJECT REPOSITORY DEPENDENCY */

    /** START INJECT CATEGORY USE CASE DEPENDENCY */
    Get.lazyPut(() => GetCategoriesUseCase(repository: Get.find()));
    Get.lazyPut(() => AddCategoryUseCase(repository: Get.find()));
    Get.lazyPut(() => UpdateCategoryUseCase(repository: Get.find()));
    Get.lazyPut(() => DeleteCategoryUseCase(repository: Get.find()));
    Get.lazyPut(
      () => CategoryUseCases(
        getUseCase: Get.find(),
        addUseCase: Get.find(),
        updateUseCase: Get.find(),
        deleteUseCase: Get.find(),
      ),
    );
    /** END INJECT CATEGORY USE CASE DEPENDENCY */

    /** START INJECT LEDGER USE CASE DEPENDENCY */
    Get.lazyPut(() => GetLedgerUseCase(repository: Get.find()));
    Get.lazyPut(() => AddLedgerUseCase(repository: Get.find()));
    Get.lazyPut(() => UpdateLedgerUseCase(repository: Get.find()));
    Get.lazyPut(() => DeleteLedgerUseCase(repository: Get.find()));
    Get.lazyPut(
      () => LedgerUseCases(
        getUseCase: Get.find(),
        addUseCase: Get.find(),
        updateUseCase: Get.find(),
        deleteUseCase: Get.find(),
      ),
    );
    /** END INJECT LEDGER USE CASE DEPENDENCY */

    /** START INJECT INCOME USE CASE DEPENDENCY */
    Get.lazyPut(() => GetIncomeUseCase(repository: Get.find()));
    Get.lazyPut(() => AddIncomeUseCase(repository: Get.find()));
    Get.lazyPut(() => UpdateIncomeUseCase(repository: Get.find()));
    Get.lazyPut(() => DeleteIncomeUseCase(repository: Get.find()));
    Get.lazyPut(
      () => IncomeUseCases(
        getUseCase: Get.find(),
        addUseCase: Get.find(),
        updateUseCase: Get.find(),
        deleteUseCase: Get.find(),
      ),
    );
    /** END INJECT INCOME USE CASE DEPENDENCY */

    /** START USER USE CASE DEPENDENCY */
    Get.lazyPut(() => ConfigurationUseCase(repository: Get.find()));
    Get.lazyPut(() => LoginUseCase(repository: Get.find()));
    Get.lazyPut(() => SocialUseCase());
    Get.lazyPut(() => UpdateLastLoginUseCase(repository: Get.find()));
    Get.lazyPut(() => RegenerateTokenUseCase(repository: Get.find()));
    Get.lazyPut(
      () => AccountantUseCases(
        configurationUseCase: Get.find(),
        loginUseCase: Get.find(),
        socialUseCase: Get.find(),
        updateLastLoginUseCase: Get.find(),
        regenerateTokenUseCase: Get.find(),
      ),
    );
    /** END USER USE CASE DEPENDENCY */

    /** START REPORT USE CASE DEPENDENCY */
    Get.lazyPut(() => GetUseCase(repository: Get.find()));
    Get.lazyPut(() => ReportUseCases(getUseCase: Get.find()));
    /** END USER USE CASE DEPENDENCY */

    /** START PAYMENT USE CASE DEPENDENCY */
    Get.lazyPut(() => PaymentGetUseCase(repository: Get.find()));
    Get.lazyPut(() => PurchaseUseCase(repository: Get.find()));
    Get.lazyPut(() => UpdateStatusUseCase(repository: Get.find()));
    Get.lazyPut(
      () => PaymentUseCases(
        getUseCase: Get.find(),
        purchaseUseCase: Get.find(),
        updateStatusUseCase: Get.find(),
      ),
    );
    /** END PAYMENT USE CASE DEPENDENCY */

    /** START RECURRING USE CASE DEPENDENCY */
    Get.lazyPut(() => GetRecurringUseCase(repository: Get.find()));
    Get.lazyPut(() => AddRecurringUseCase(repository: Get.find()));
    Get.lazyPut(() => UpdateRecurringUseCase(repository: Get.find()));
    Get.lazyPut(() => DeleteRecurringUseCase(repository: Get.find()));
    Get.lazyPut(
      () => RecurringUseCases(
        getUseCase: Get.find(),
        addUseCase: Get.find(),
        updateUseCase: Get.find(),
        deleteUseCase: Get.find(),
      ),
    );
    /** END RECURRING USE CASE DEPENDENCY */

    /** START FAQ USE CASE DEPENDENCY */
    Get.lazyPut(() => GetFaqsUseCase(repository: Get.find()));
    Get.lazyPut(
      () => FaqUseCases(
        getUseCase: Get.find(),
      ),
    );
    /** END FAQ USE CASE DEPENDENCY */
  }
}
