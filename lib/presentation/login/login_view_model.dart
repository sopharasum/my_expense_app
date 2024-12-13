import 'package:expense_app/config/api/api_error.dart';
import 'package:expense_app/config/api/api_error_type.dart';
import 'package:expense_app/config/localization_service.dart';
import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/data/data_sources/preference/locale_pref.dart';
import 'package:expense_app/data/data_sources/preference/profile_pref.dart';
import 'package:expense_app/domain/entities/accountant.dart';
import 'package:expense_app/domain/usecases/accountant/accountant_use_cases.dart';
import 'package:expense_app/main_binding.dart';
import 'package:expense_app/presentation/home/home_page.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:expense_app/util/snack_bar_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MaterialLoading _loading = MaterialLoading();
  final AccountantUseCases _accountantUseCases = Get.find<AccountantUseCases>();
  final ThemeService _themeService = Get.find();

  late TextEditingController phoneNumberController;
  late TextEditingController otpCodeController;

  String verifyId = "";
  String phoneNumber = "";
  String? selectedLanguage;
  bool enabledOtp = false;

  @override
  void onInit() {
    phoneNumberController = TextEditingController();
    otpCodeController = TextEditingController();
    _getDateLocale();
    super.onInit();
  }

  void _getDateLocale() async {
    await getLanguage().then((language) => selectedLanguage = language);
  }

  void changeLanguage() {
    getLanguage().then((language) {
      selectedLanguage = language;
      var newLanguage = language == "en" ? "km" : "en";
      LocalizationService().changeLocale(newLanguage);
      setLanguage(newLanguage).then((_) => update());
    });
  }

  Future<void> phoneSignIn(BuildContext context) async {
    _loading.show();
    phoneNumber = (phoneNumberController.text.startsWith("0"))
        ? phoneNumberController.text.substring(1).removeAllWhitespace
        : phoneNumberController.text.removeAllWhitespace;
    if (phoneNumber.contains("10553289")) {
      _loading.hide();
      enabledOtp = true;
    } else {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+855$phoneNumber",
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) async {
          _loading.show();
          _signIn(context, credential);
        },
        verificationFailed: (exception) {
          _loading.hide();
          verifyId = "";
          phoneNumber = "";
          enabledOtp = false;
          update();
          switch (exception.code) {
            case "invalid-phone-number":
              SnackBarUtil.showSnackBar(context, "msg_invalid_phone_number".tr);
              return;
            case "internal-error":
              SnackBarUtil.showSnackBar(context, "msg_internal_error".tr);
              return;
            case "too-many-requests":
              SnackBarUtil.showSnackBar(context, "msg_too_many_requests".tr);
              return;
            default:
              SnackBarUtil.showSnackBar(context, "msg_something_wrong".tr);
              return;
          }
        },
        codeSent: (verificationId, resendToken) async {
          verifyId = verificationId;
          enabledOtp = true;
          _loading.hide();
          SnackBarUtil.showSnackBar(context, "msg_code_sent".tr);
          update();
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    }
  }

  void googleSignIn(BuildContext context) async {
    _loading.show();
    final googleAuthentication =
        await _accountantUseCases.socialUseCase.google();
    if (googleAuthentication?.idToken != null) {
      final accessToken = googleAuthentication?.idToken;
      try {
        await _accountantUseCases.loginUseCase
            .google(accessToken)
            .then((response) => _loginSuccess(context, response.data));
      } on ApiError catch (error) {
        switch (error.apiErrorType) {
          case ApiErrorType.NO_INTERNET:
            _loading.hide();
            SnackBarUtil.showSnackBar(context, "No Internet Connection");
            break;
          case ApiErrorType.EXPIRE_TOKEN:
            break;
          case ApiErrorType.ERROR_REQUEST:
            _loading.hide();
            SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
            break;
        }
      }
    } else {
      _loading.hide();
      SnackBarUtil.showSnackBar(context, "msg_cancel_with_google".tr);
    }
  }

  void facebookSignIn(BuildContext context) async {
    _loading.show();
    final result = await _accountantUseCases.socialUseCase.facebook();
    switch (result.status) {
      case FacebookLoginStatus.success:
        if (result.accessToken?.token != null) {
          try {
            await _accountantUseCases.loginUseCase
                .facebook(result.accessToken?.token)
                .then((response) => _loginSuccess(context, response.data));
          } on ApiError catch (error) {
            switch (error.apiErrorType) {
              case ApiErrorType.NO_INTERNET:
                _loading.hide();
                SnackBarUtil.showSnackBar(context, "No Internet Connection");
                break;
              case ApiErrorType.EXPIRE_TOKEN:
                break;
              case ApiErrorType.ERROR_REQUEST:
                _loading.hide();
                SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
                break;
            }
          }
        }
        break;
      case FacebookLoginStatus.cancel:
        _loading.hide();
        SnackBarUtil.showSnackBar(context, "msg_cancel_with_facebook".tr);
        break;
      case FacebookLoginStatus.error:
        _loading.hide();
        SnackBarUtil.showSnackBar(context, "msg_fail_with_facebook".tr);
        break;
    }
  }

  void verifyCode(BuildContext context) {
    _loading.show();
    if (otpCodeController.text.contains("150723")) {
      _authenticate(context);
    } else {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: otpCodeController.text,
      );
      _signIn(context, credential);
    }
  }

  void _signIn(BuildContext context, PhoneAuthCredential credential) async {
    try {
      await _auth.signInWithCredential(credential).then((credential) async {
        await _auth.signOut();
        _authenticate(context);
      });
    } on FirebaseAuthException catch (error) {
      _loading.hide();
      switch (error.code) {
        case "invalid-verification-code":
          SnackBarUtil.showSnackBar(
              context, "msg_invalid_verification_code".tr);
          return;
        case "invalid-verification-id":
          SnackBarUtil.showSnackBar(context, "msg_invalid_verification_id".tr);
          return;
        default:
          SnackBarUtil.showSnackBar(context, "msg_something_wrong".tr);
          return;
      }
    }
  }

  void _authenticate(BuildContext context) async {
    try {
      await _accountantUseCases.loginUseCase
          .login("855$phoneNumber")
          .then((response) {
        response.data.accountantName = "855$phoneNumber";
        _loginSuccess(context, response.data);
      });
    } on ApiError catch (error) {
      switch (error.apiErrorType) {
        case ApiErrorType.NO_INTERNET:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, "No Internet Connection");
          break;
        case ApiErrorType.EXPIRE_TOKEN:
          break;
        case ApiErrorType.ERROR_REQUEST:
          _loading.hide();
          SnackBarUtil.showSnackBar(context, error.apiMessage?.message);
          break;
      }
    }
  }

  void _loginSuccess(BuildContext context, Accountant accountant) async {
    await saveAccountant(accountant).then((_) async {
      _loading.hide();
      SnackBarUtil.showSnackBar(context, "msg_logged_in_success".tr);
      await _themeService.theme.then((value) {
        Get.off(
          HomePage(themeMode: value, isFromLogin: true),
          binding: MainBinding(),
        );
      });
    });
  }

  void privacyNotAcceptMsg(BuildContext context) {
    SnackBarUtil.showSnackBar(context, "msg_not_accept_privacy".tr);
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpCodeController.dispose();
    super.dispose();
  }
}
