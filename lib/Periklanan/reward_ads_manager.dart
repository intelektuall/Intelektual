import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAdsManager {
  static RewardedAd? _rewardedAd;

  static const String rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  /// Return TRUE jika user menonton minimal 5 detik
  static Future<bool> showRewardedAd(BuildContext context) async {
    bool rewardGranted = false;
    final completer = Completer<bool>();

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          final startTime = DateTime.now();

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) {
              ad.dispose();
              if (!completer.isCompleted) {
                completer.complete(rewardGranted);
              }
            },
            onAdFailedToShowFullScreenContent: (_, __) {
              ad.dispose();
              if (!completer.isCompleted) {
                completer.complete(false);
              }
            },
          );

          ad.show(
            onUserEarnedReward: (_, __) {
              final watchedSeconds =
                  DateTime.now().difference(startTime).inSeconds;
              if (watchedSeconds >= 5) {
                rewardGranted = true;
              }
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Reward ad failed: $error');
          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
      ),
    );

    return completer.future;
  }
}
