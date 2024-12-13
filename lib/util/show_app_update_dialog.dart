import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/configuration.dart';
import 'package:expense_app/util/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_minimizer/flutter_app_minimizer.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ShowAppUpdateDialog {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final String versionTitle = "msg_new_version_available".tr;
  final String versionMessage = "msg_new_version_update".tr;
  final String versionUpdate = "button_confirm_update".tr;
  final String versionNo = "button_reject_update".tr;
  late final BuildContext context;
  late final Function(bool) clickUpdate;

  void checkForMaintenance(
    BuildContext context,
    Configuration data,
    Function(bool) clickUpdate,
  ) async {
    this.context = context;
    this.clickUpdate = clickUpdate;
    if (data.maintain == true) {
      _showMaintainDialog();
    } else {
      _checkUpForUpdate(data);
    }
  }

  void _showMaintainDialog() async {
    var dialogTitle = "msg_maintain_available".tr;
    var dialogMessage = "msg_maintain_later".tr;
    var dialogButton = "button_confirm_maintain".tr;

    if (!Platform.isIOS) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogMessage),
          actions: [
            TextButton(
              onPressed: () {
                clickUpdate.call(true);
                Navigator.pop(context);
                FlutterAppMinimizer.minimize();
              },
              child: Text(
                dialogButton,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(dialogTitle),
        content: Text(dialogMessage),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(dialogButton),
            onPressed: () {
              clickUpdate.call(true);
              Navigator.pop(context);
              FlutterAppMinimizer.minimize();
            },
          ),
        ],
      ),
    );
  }

  void _checkUpForUpdate(Configuration data) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (!Platform.isIOS) {
      _checkUpForAndroid(packageInfo, data);
    } else {
      final iOSVersion = _calculateVersion(packageInfo.version);
      final responseVersion = _calculateVersion(data.ios);
      if (iOSVersion < responseVersion) {
        _showIOSUpdateDialog(data.forceUpdate);
      }
    }
  }

  void _checkUpForAndroid(PackageInfo packageInfo, Configuration data) async {
    final androidVersion = _calculateVersion(packageInfo.version);
    final responseVersion = _calculateVersion(data.android);
    if (androidVersion < responseVersion) {
      _showAndroidUpdateDialog(
        data.forceUpdate,
        false,
        packageInfo.packageName,
      );
    }
  }

  void _showAndroidUpdateDialog(
    bool forceUpdate,
    bool isHuawei,
    String packageName,
  ) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(versionTitle),
        content: Text(versionMessage),
        actions: [
          if (forceUpdate == false)
            TextButton(
              onPressed: () {
                clickUpdate.call(false);
                Navigator.pop(context);
              },
              child: Text(
                versionNo,
                style: TextStyle(color: Colors.red),
              ),
            ),
          TextButton(
            onPressed: () {
              clickUpdate.call(true);
              Navigator.pop(context);
              _openGooglePlayStore(packageName);
            },
            child: Text(
              versionUpdate,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _openGooglePlayStore(String appPackageName) {
    try {
      launchURL(context, "market://details?id=" + appPackageName);
    } on PlatformException catch (_) {
      launchURL(context,
          "https://play.google.com/store/apps/details?id=" + appPackageName);
    } finally {
      launchURL(context,
          "https://play.google.com/store/apps/details?id=" + appPackageName);
    }
  }

  void _showIOSUpdateDialog(bool forceUpdate) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(versionTitle),
        content: Text(versionMessage),
        actions: <Widget>[
          if (!forceUpdate)
            CupertinoDialogAction(
              child: Text(versionNo),
              onPressed: () {
                clickUpdate.call(false);
                Navigator.pop(context);
              },
            ),
          CupertinoDialogAction(
            child: Text(versionUpdate),
            onPressed: () {
              clickUpdate.call(true);
              Navigator.pop(context);
              launchURL(context, privacyUrl);
            },
          ),
        ],
      ),
    );
  }

  int _calculateVersion(String version) {
    final responseVersion = version.split(".");
    var finalResponseVersion = 0;
    responseVersion.forEach((digit) {
      finalResponseVersion += int.parse(digit);
    });
    return finalResponseVersion;
  }
}
