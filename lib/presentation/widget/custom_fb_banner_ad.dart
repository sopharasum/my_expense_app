import 'package:expense_app/config/ads/ad_helper.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/data/data_sources/preference/payment_pref.dart';
import 'package:expense_app/domain/entities/payment.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';

class CustomFBBannerAds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPayment(),
      builder: (context, snapshot) => (snapshot.data != null &&
              ((snapshot.data) as Payment).paymentStatus ==
                  PaymentStatus.ACTIVE.name)
          ? Container()
          : FacebookBannerAd(
              placementId: AdHelper.fbBannerAdPlacementId,
              bannerSize: BannerSize.STANDARD,
              listener: (result, value) {
                switch (result) {
                  case BannerAdResult.ERROR:
                    break;
                  case BannerAdResult.LOADED:
                    break;
                  case BannerAdResult.CLICKED:
                    break;
                  case BannerAdResult.LOGGING_IMPRESSION:
                    break;
                }
              },
            ),
    );
  }
}
