import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:flutter/material.dart';

class CustomSocialButton extends StatelessWidget {
  final String label;
  final Color color;
  final String image;
  final Function() onTap;

  CustomSocialButton(this.label, this.color, this.image, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("asset/icon/$image", height: 20),
            SizedBox(width: 10),
            CustomText(text: label, color: Colors.white, fontSize: 16),
          ],
        ),
      ),
    );
  }
}
