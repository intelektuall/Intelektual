import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/user_access_provider.dart';
import '../widgets/customSnackbar/customC_snackbar.dart';
import '../../Periklanan/reward_ads_manager.dart';

class CardAccessGate {
  /// Return TRUE jika card boleh dibuka
  static Future<bool> requestAccess(BuildContext context) async {
    final access = context.read<UserAccessProvider>();

    // 🔑 Ambil premium dari SharedPreferences (SUMBER UTAMA)
    final prefs = await SharedPreferences.getInstance();
    final isPremiumPrefs = prefs.getBool('is_premium') ?? false;

    // 👑 PREMIUM → LANGSUNG AKSES, NO COIN, NO SNACKBAR
    if (isPremiumPrefs) {
      return true;
    }

    // 🪙 GRATIS + masih ada coin
    if (access.coins > 0) {
      access.consumeCoin();
      return true;
    }

    // 📺 GRATIS + coin habis → reward ads
    final rewarded = await RewardAdsManager.showRewardedAd();

    // ✅ REWARD COIN HANYA UNTUK NON-PREMIUM
    if (rewarded) {
      access.addCoins(5);

      noUndoCustomSnackbar(
        context,
        message: "🎉 Get 5 Coins! Tap again to open",
      );

      return false; // tap ulang
    }

    // ❌ gagal nonton iklan
    noUndoCustomSnackbar(
      context,
      message: "❌ Watch ads to unlock more accesses",
    );

    return false;
  }
}
