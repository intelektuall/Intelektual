import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardAdsManager {
  static RewardedAd? _rewardedAd;
  static bool _isShowing = false;

  static const String rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  /// Return TRUE jika:
  /// - user premium
  /// - atau reward ads benar-benar didapat
  static Future<bool> showRewardedAd() async {
    // 🔑 CEK PREMIUM
    final prefs = await SharedPreferences.getInstance();
    final isPremium = prefs.getBool('is_premium') ?? false;

    if (isPremium) {
      debugPrint('👑 Premium user → reward auto granted');
      return true;
    }

    // 🔒 Anti spam
    if (_isShowing) return false;
    _isShowing = true;

    final completer = Completer<bool>();
    bool rewardGranted = false;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) {
              ad.dispose();
              _rewardedAd = null;
              _isShowing = false;

              if (!completer.isCompleted) {
                completer.complete(rewardGranted);
              }
            },
            onAdFailedToShowFullScreenContent: (_, __) {
              ad.dispose();
              _rewardedAd = null;
              _isShowing = false;

              if (!completer.isCompleted) {
                completer.complete(false);
              }
            },
          );

          ad.show(
            onUserEarnedReward: (_, __) {
              rewardGranted = true; // ✅ valid sesuai Google
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Reward ad failed: $error');
          _isShowing = false;

          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
      ),
    );

    return completer.future;
  }
}
