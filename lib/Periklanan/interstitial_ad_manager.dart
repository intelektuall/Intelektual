import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterstitialAdManager {
  static final InterstitialAdManager _instance =
      InterstitialAdManager._internal();
  factory InterstitialAdManager() => _instance;
  InterstitialAdManager._internal();

  static const String _adUnitId = 'ca-app-pub-3940256099942544/1033173712';

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  bool _isShowingAd = false;

  static bool _submitSuccessful = false;

  /// ================= PREMIUM CHECK =================
  Future<bool> _isPremiumUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_premium') ?? false;
  }

  /// ================= SUBMIT FLAG =================
  static void setSubmitSuccessful() {
    _submitSuccessful = true;
    print('✅ Flag submit berhasil di-set');
  }

  static bool checkAndResetSubmitFlag() {
    final result = _submitSuccessful;
    _submitSuccessful = false;
    print('📝 Cek flag submit: $result');
    return result;
  }

  /// ================= LOAD INTERSTITIAL =================
  Future<void> loadInterstitialAd() async {
    // 🔐 BLOK TOTAL JIKA PREMIUM
    if (await _isPremiumUser()) {
      print('👑 Premium aktif → tidak load interstitial');
      return;
    }

    if (_isAdLoaded || _isShowingAd) return;

    try {
      await _disposeAd();

      await InterstitialAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isAdLoaded = true;
            _setupAdListeners(ad);
            print('✅ Interstitial berhasil dimuat');
          },
          onAdFailedToLoad: (error) {
            _isAdLoaded = false;
            _interstitialAd = null;
            print('❌ Gagal memuat interstitial: $error');
          },
        ),
      );
    } catch (e) {
      _isAdLoaded = false;
      print('⚠️ Error loading interstitial: $e');
    }
  }

  /// ================= AD LISTENERS =================
  void _setupAdListeners(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('🎬 Interstitial ditampilkan');
      },
      onAdDismissedFullScreenContent: (ad) {
        print('✅ Interstitial ditutup');
        _isShowingAd = false;
        _isAdLoaded = false;
        _disposeAd();

        // Preload iklan berikutnya (jika non-premium)
        Future.delayed(const Duration(seconds: 1), loadInterstitialAd);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('❌ Gagal menampilkan interstitial: $error');
        _isShowingAd = false;
        _isAdLoaded = false;
        _disposeAd();
      },
    );
  }

  /// ================= SHOW INTERSTITIAL =================
  Future<void> showInterstitialAd() async {
    // 🔐 BLOK TOTAL JIKA PREMIUM
    if (await _isPremiumUser()) {
      print('👑 Premium aktif → interstitial tidak ditampilkan');
      return;
    }

    if (_isShowingAd) {
      print('⏳ Interstitial sedang tampil, skip');
      return;
    }

    if (_isAdLoaded && _interstitialAd != null) {
      try {
        print('🎬 Menampilkan interstitial...');
        await _interstitialAd!.show();
      } catch (e) {
        print('⚠️ Error saat show interstitial: $e');
        _isAdLoaded = false;
        _isShowingAd = false;
        _disposeAd();
      }
    } else {
      print('📥 Interstitial belum siap, load dulu...');
      await loadInterstitialAd();

      await Future.delayed(const Duration(milliseconds: 800));

      if (_isAdLoaded && !_isShowingAd && _interstitialAd != null) {
        print('🎬 Menampilkan interstitial setelah load...');
        await _interstitialAd!.show();
      } else {
        print('❌ Interstitial masih belum siap');
      }
    }
  }

  /// ================= CHECK & SHOW =================
  Future<void> checkAndShowInterstitialAd() async {
    // 🔐 BLOK TOTAL JIKA PREMIUM
    if (await _isPremiumUser()) {
      print('👑 Premium aktif → skip interstitial');
      return;
    }

    if (checkAndResetSubmitFlag()) {
      print('🚀 Submit berhasil → tampilkan interstitial');
      await Future.delayed(const Duration(milliseconds: 500));
      await showInterstitialAd();
    } else {
      print('📊 Tidak ada submit → skip interstitial');
    }
  }

  /// ================= DISPOSE =================
  Future<void> _disposeAd() async {
    if (_interstitialAd != null) {
      await _interstitialAd!.dispose();
      _interstitialAd = null;
    }
    _isAdLoaded = false;
    _isShowingAd = false;
  }

  void dispose() {
    _disposeAd();
  }
}
