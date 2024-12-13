import 'package:expense_app/data/data_sources/preference/profile_pref.dart';
import 'package:expense_app/domain/usecases/accountant/regenerate_token_use_case.dart';
import 'package:expense_app/presentation/login/login_page.dart';
import 'package:get/get.dart';

Future<bool> regenerateToken() async {
  final RegenerateTokenUseCase regenerateTokenUseCase = Get.find();
  bool _isSuccess = false;
  try {
    await regenerateTokenUseCase.regenerate().then((response) async {
      await saveAccountant(response.data).then((_) {
        _isSuccess = true;
      });
    });
  } catch (error) {
    _isSuccess = false;
    await removeLoggedAccountant().then((_) {
      Get.snackbar("", "Your session has expired. Please Login Again");
      Get.offAll(LoginPage());
    });
  }
  return _isSuccess;
}
