import 'package:expense_app/domain/entities/plan.dart';
import 'package:expense_app/presentation/donate/donate_view_model.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanItem extends StatelessWidget {
  final DonateViewModel viewModel;
  final Plan item;

  PlanItem(this.viewModel, this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => viewModel.purchase(item),
      child: Card(
        elevation: 3,
        child: Stack(
          children: [
            Container(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: item.name,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  item.discount != null
                      ? Column(
                          children: [
                            CustomText(
                              text: "\$ ${(item.price - item.discount!)}",
                              fontSize: 22,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            Text(
                              "\$ ${item.price}",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.red),
                            ),
                          ],
                        )
                      : CustomText(
                          text: "\$ ${item.price}",
                          fontSize: 22,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                  CustomText(
                    text:
                        "${"label_validity".tr} ${item.numberOfDays} ${"label_validity_days".tr}",
                  )
                ],
              ),
            ),
            item.discount != null
                ? Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      width: Get.width * .12,
                      height: Get.height * .03,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                        color: Colors.red,
                      ),
                      child: CustomText(
                        text:
                            "-${viewModel.calculateDiscountPercentage(item.price, item.discount!).toStringAsFixed(0)}%",
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
