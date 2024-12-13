import 'package:expense_app/config/constance.dart';
import 'package:expense_app/presentation/login/login_view_model.dart';
import 'package:expense_app/presentation/widget/custom_action.dart';
import 'package:expense_app/presentation/widget/custom_red_button.dart';
import 'package:expense_app/presentation/widget/custom_social_button.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/util/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool phoneError = false;
  bool otpCodeError = false;
  bool? isAgree = true;

  @override
  Widget build(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    return GetBuilder<LoginViewModel>(
      init: LoginViewModel(),
      builder: (viewModel) => Scaffold(
        appBar: AppBar(
          actions: [
            CustomAction(
              widget: Image.asset(
                "asset/flag/${viewModel.selectedLanguage == "en" ? "kh.png" : "en.png"}",
                width: 20,
                height: 24,
              ),
              text: "label_icon_language".tr,
              onTap: () => viewModel.changeLanguage(),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black,
                        ),
                        child: Icon(
                          Icons.money_rounded,
                          size: 90,
                          color: Colors.white,
                        ),
                      ),
                      CustomText(
                        textAlign: TextAlign.center,
                        text: "label_welcome_back".tr,
                        fontSize: 25,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        textAlign: TextAlign.center,
                        text: "label_sign_to_continue".tr,
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      TextFormField(
                        maxLength: 15,
                        controller: viewModel.phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "label_phone_number_hint".tr,
                          errorText:
                              phoneError ? "msg_phone_number_error".tr : null,
                          counterText: "",
                        ),
                      ),
                      TextFormField(
                        controller: viewModel.otpCodeController,
                        enabled: viewModel.enabledOtp,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: "label_otp_code_hint".tr,
                          errorText:
                              otpCodeError ? "msg_otp_code_error".tr : null,
                          counterText: "",
                        ),
                      ),
                      SizedBox(height: 25),
                      InkWell(
                        onTap: () {
                          if (isAgree == true) {
                            setState(() {
                              phoneError =
                                  viewModel.phoneNumberController.text.isEmpty;
                              otpCodeError =
                                  viewModel.otpCodeController.text.isEmpty;
                            });
                            if (viewModel.enabledOtp) {
                              if (!otpCodeError) {
                                if (!currentFocus.hasPrimaryFocus &&
                                    currentFocus.focusedChild != null) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                                viewModel.verifyCode(context);
                              }
                            } else {
                              if (!phoneError) {
                                if (!currentFocus.hasPrimaryFocus &&
                                    currentFocus.focusedChild != null) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                                viewModel.phoneSignIn(context);
                              }
                            }
                          } else {
                            viewModel.privacyNotAcceptMsg(context);
                          }
                        },
                        child: CustomButton(
                            viewModel.enabledOtp
                                ? "button_login".tr
                                : "button_request_otp_code".tr,
                            Colors.blue),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16, right: 8),
                                child: Divider(thickness: 1),
                              ),
                            ),
                            CustomText(
                              text: "label_login_as".tr,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 16),
                                child: Divider(thickness: 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomSocialButton(
                              "Facebook",
                              Colors.blue,
                              "facebook.png",
                              () {
                                isAgree == true
                                    ? viewModel.facebookSignIn(context)
                                    : viewModel.privacyNotAcceptMsg(context);
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomSocialButton(
                              "Google",
                              Colors.red,
                              "google.png",
                              () {
                                isAgree == true
                                    ? viewModel.googleSignIn(context)
                                    : viewModel.privacyNotAcceptMsg(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                              value: isAgree,
                              onChanged: (value) {
                                setState(() {
                                  isAgree = value;
                                });
                              }),
                          RichText(
                            text: TextSpan(
                                text: "label_accept_privacy".tr,
                                children: [
                                  TextSpan(
                                      text: "label_privacy".tr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            launchURL(context, privacyUrl))
                                ],
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Siemreap")),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "label_instruction".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
