import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_access_provider.dart';
import '../widgets/customSnackbar/customC_snackbar.dart';
import '../../Periklanan/reward_ads_manager.dart';

class CardAccessGate {
  /// Return TRUE jika card boleh dibuka
  static Future<bool> requestAccess(BuildContext context) async {
    final access = context.read<UserAccessProvider>();

    // 👑 Premium → bebas
    if (access.isPremium) return true;

    // 🪙 Masih ada coin
    if (access.coins > 0) {
      access.consumeCoin();
      return true;
    }

    // 📺 Coin habis → Reward Ads
    final rewarded = await RewardAdsManager.showRewardedAd(context);

    if (rewarded) {
      access.addCoins(5);

      noUndoCustomSnackbar(
        context,
        message: "🎉 Get 5 Coins! Tap again to open",
      );

      return false; // user harus tap ulang
    }

    noUndoCustomSnackbar(
      context,
      message: "❌ Watch ads to unlock more accesses",
    );

    return false;
  }
}
