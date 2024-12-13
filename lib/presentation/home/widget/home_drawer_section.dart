import 'package:expense_app/config/constance.dart';
import 'package:expense_app/main_binding.dart';
import 'package:expense_app/presentation/category/category_page.dart';
import 'package:expense_app/presentation/donate/donate_page.dart';
import 'package:expense_app/presentation/faq/faq_page.dart';
import 'package:expense_app/presentation/home/home_view_model.dart';
import 'package:expense_app/presentation/recurring/recurring_page.dart';
import 'package:expense_app/presentation/transaction/transaction_page.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/util/entry_util.dart';
import 'package:expense_app/util/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Drawer homeDrawer(BuildContext context, HomeViewModel viewModel) {
  return Drawer(
    child: Column(
      children: [
        SizedBox(
          height:
              viewModel.payment != null ? Get.height * .24 : Get.height * .17,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: viewModel.isDarkMode
                  ? Colors.black.withOpacity(.3)
                  : Colors.blue,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "label_welcome_back".tr,
                        color: Colors.white,
                      ),
                      CustomText(
                        text: viewModel.accountant?.accountantName ??
                            "label_other_n_a".tr,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      if (viewModel.payment != null)
                        CustomText(
                          text:
                              "${"label_subscribed".tr} ${viewModel.payment?.paymentName}\n${"label_subscribe_valid".tr} ${EntryUtil.showDate(viewModel.selectedLanguage, viewModel.payment?.paymentEndDate)}",
                          color: Colors.white,
                          fontSize: 12,
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => viewModel.switchTheme(),
                  child: Icon(
                    viewModel.isDarkMode
                        ? Icons.wb_sunny_outlined
                        : Icons.nights_stay_rounded,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        CustomDrawerItem(
          icon: Icons.card_giftcard_rounded,
          label: "title_drawer_donate".tr,
          viewModel: viewModel,
          onTap: () => Get.to(() => DonatePage()),
        ),
        CustomDrawerItem(
          icon: Icons.payment_rounded,
          label: "title_drawer_transaction".tr,
          viewModel: viewModel,
          onTap: () => Get.to(() => TransactionPage()),
        ),
        CustomDrawerItem(
          icon: Icons.category_outlined,
          label: "title_drawer_category".tr,
          viewModel: viewModel,
          onTap: () => Get.to(
            () => CategoryPage(
              title: "title_drawer_category".tr,
              language: viewModel.selectedLanguage.toString(),
              notBack: true,
            ),
            binding: MainBinding(),
          ),
        ),
        CustomDrawerItem(
          icon: Icons.calendar_today_outlined,
          label: "title_drawer_recurring".tr,
          viewModel: viewModel,
          onTap: () => Get.to(() => RecurringPage(viewModel.isDarkMode),
              binding: MainBinding()),
        ),
        CustomDrawerItem(
          icon: Icons.question_answer_outlined,
          label: "title_drawer_faq".tr,
          viewModel: viewModel,
          onTap: () => Get.to(
            () => FAQPage(viewModel.selectedLanguage.toString()),
            binding: MainBinding(),
          ),
        ),
        CustomDrawerItem(
          icon: Icons.info_outline_rounded,
          label: "title_drawer_about_app".tr,
          viewModel: viewModel,
          onTap: () => launchURL(context, webUrl),
        ),
        CustomDrawerItem(
          icon: Icons.logout,
          label: "msg_logout_title".tr,
          viewModel: viewModel,
          onTap: () => viewModel.logout(),
        ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => launchURL(context, fbUrl),
            child: Container(
              decoration: BoxDecoration(
                  color: viewModel.isDarkMode
                      ? Colors.black.withOpacity(.3)
                      : Colors.blue,
                  borderRadius: BorderRadius.circular(4)),
              padding: EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.facebook_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Expense - Money Tracking",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      CustomText(
                        text: "title_drawer_short_desc".tr,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(height: 1),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "v${viewModel.appVersion}",
                fontSize: 11,
                color: Colors.grey,
              ),
              CustomText(
                text:
                    "${"title_drawer_last_login".tr}: ${viewModel.getLastLogin()}",
                fontSize: 11,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ],
    ),
  );
}

class CustomDrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final HomeViewModel viewModel;
  final Function onTap;

  CustomDrawerItem({
    required this.icon,
    required this.label,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            viewModel.isDarkMode ? Colors.white.withOpacity(.3) : Colors.blue,
      ),
      title: CustomText(text: label),
      onTap: () {
        Navigator.of(context).pop();
        onTap.call();
      },
    );
  }
}
