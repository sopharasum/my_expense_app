import 'package:expense_app/config/ads/ad_helper.dart';
import 'package:expense_app/config/constance.dart';
import 'package:expense_app/data/data_sources/preference/ads_source_pref.dart';
import 'package:expense_app/data/data_sources/preference/payment_pref.dart';
import 'package:expense_app/util/loading/material_loading.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void showInterstitialAd({
  MaterialLoading? loading,
  bool? notHidden,
  bool? isShow = true,
  Function()? onCompleted,
  Function(InterstitialAd)? onAdLoaded,
}) async {
  await getPayment().then((payment) {
    if (payment?.paymentStatus != PaymentStatus.ACTIVE.name) {
      getAdsSource().then((value) {
        if (value == AdsSource.GOOGLE.name || isShow == false) {
          InterstitialAd.load(
            adUnitId: AdHelper.interstitialAdUnitId,
            request: AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (InterstitialAd ad) {
                if (isShow == true) {
                  ad.show();
                  ad.fullScreenContentCallback = FullScreenContentCallback(
                      onAdDismissedFullScreenContent: (ad) {
                    if (notHidden == null) loading?.hide();
                    onCompleted?.call();
                  });
                } else {
                  onAdLoaded?.call(ad);
                }
              },
              onAdFailedToLoad: (LoadAdError error) {
                if (notHidden == null) loading?.hide();
                onCompleted?.call();
              },
            ),
          );
        } else {
          FacebookInterstitialAd.loadInterstitialAd(
            placementId: AdHelper.fbInterstitialAdPlacementId,
            listener: (result, value) {
              if (notHidden == null) loading?.hide();
              if (result == InterstitialAdResult.LOADED)
                FacebookInterstitialAd.showInterstitialAd();
              if (result == InterstitialAdResult.DISMISSED) onCompleted?.call();
              if (result == InterstitialAdResult.ERROR) onCompleted?.call();
            },
          );
        }
      });
    } else {
      if (notHidden == null) loading?.hide();
      onCompleted?.call();
    }
  });
}
