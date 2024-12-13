import 'package:expense_app/config/ads/ad_helper.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/data/data_sources/preference/ads_source_pref.dart';
import 'package:expense_app/data/data_sources/preference/payment_pref.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomAdsBanner extends StatefulWidget {
  @override
  State<CustomAdsBanner> createState() => _CustomAdsBannerState();
}

class _CustomAdsBannerState extends State<CustomAdsBanner> {
  BannerAd? _bannerAd;
  bool _isSubscribe = false;
  bool _isBannerAdReady = false;
  bool _isFacebookAds = false;

  @override
  void initState() {
    super.initState();
    getPayment().then((value) {
      _isSubscribe = value?.paymentStatus == PaymentStatus.ACTIVE.name;
      getAdsSource().then((value) {
        if (value == AdsSource.GOOGLE.name) {
          _initGoogleAdsBanner();
        } else {
          setState(() {
            _isFacebookAds = true;
          });
        }
      });
    });
  }

  void _initGoogleAdsBanner() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.getPortraitInlineAdaptiveBannerAdSize(Get.width.toInt()),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
            _isFacebookAds = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerAdReady = false;
          _isFacebookAds = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    return _isSubscribe
        ? Container()
        : _isFacebookAds
            ? FacebookBannerAd(
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
              )
            : _isBannerAdReady
                ? Container(
                    height: 60,
                    width: _bannerAd?.size.width.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  )
                : Container();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
