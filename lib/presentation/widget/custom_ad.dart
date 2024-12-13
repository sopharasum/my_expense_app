import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomAd extends StatelessWidget {
  final bool isAdLoaded;
  final BannerAd? bannerAd;

  CustomAd(this.isAdLoaded, this.bannerAd);

  @override
  Widget build(BuildContext context) {
    return isAdLoaded
        ? Container(
            height: bannerAd?.size.height.toDouble(),
            width: bannerAd?.size.width.toDouble(),
            child: AdWidget(ad: bannerAd!),
          )
        : Container();
  }
}
