import 'package:expense_app/config/theme/theme_service.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  final ThemeService _themeService = Get.find();

  void showSubscription(BuildContext context, Function onConfirm) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(
          text: "title_tired_of_ads".tr,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        content: CustomText(
          text: "msg_subscribe_plan".tr,
          fontSize: 15,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: CustomText(
              text: "msg_subscribe_later".tr,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm.call();
            },
            child: CustomText(
              text: "msg_subscribe_now".tr,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  void showPayment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(
          text: "title_payment_instruction".tr,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "msg_payment_instruction".tr,
              textAlign: TextAlign.center,
              fontSize: 15,
            ),
            _buildCardPayment(
                "asset/icon/aba.png", "000 394 646", "SUM SOPHARA"),
            SizedBox(height: 5),
            _buildCardPayment(
                "asset/icon/acleda.png", "0967844442", "SUM SOPHARA"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: CustomText(
              text: "label_payment_done".tr,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }

  void showConfirm(
    BuildContext context,
    String title,
    String msg,
    Function onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(
          text: title,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        content: CustomText(text: msg, fontSize: 15),
        actions: <Widget>[
          TextButton(
            child: CustomText(
              text: "button_reject_delete_category".tr,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: CustomText(
              text: "button_confirm_delete_category".tr,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
              onConfirm.call();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardPayment(String image, String id, String name) {
    return FutureBuilder(
      future: _themeService.loadThemeFromPref(),
      builder: (context, snapshot) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: (snapshot.data != null && snapshot.data == true)
                ? Colors.white
                : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          margin: EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(image, height: 40, width: 40),
              SizedBox(height: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "label_donate_acc_id".tr,
                      style: TextStyle(
                        fontFamily: "Siemreap",
                      ),
                      children: [
                        TextSpan(
                          text: id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "label_donate_acc_name".tr,
                      style: TextStyle(
                        fontFamily: "Siemreap",
                      ),
                      children: [
                        TextSpan(
                          text: name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
