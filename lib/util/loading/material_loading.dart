import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ProgressDialog.dart';

class MaterialLoading {
  ProgressDialog? _progressDialog;

  void show() {
    if (_progressDialog == null) {
      _progressDialog = ProgressDialog(
        context: Get.context!,
        blur: 0.1,
        dismissable: false,
        animationDuration: Duration(milliseconds: 500),
        loadingWidget: Container(
          height: 80.0,
          width: 80.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.red,
            ),
          ),
        ), onDismiss: (){},
      );
    }
    _progressDialog?.show();
  }

  void hide() {
    if (_progressDialog != null) {
      _progressDialog?.dismiss();
    }
  }
}
