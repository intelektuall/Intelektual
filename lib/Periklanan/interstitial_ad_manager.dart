import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  static final InterstitialAdManager _instance = InterstitialAdManager._internal();
  factory InterstitialAdManager() => _instance;
  InterstitialAdManager._internal();

  static const String _adUnitId = 'ca-app-pub-3940256099942544/1033173712';
  
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  bool _isShowingAd = false;
  
  static bool _submitSuccessful = false;

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

  Future<void> loadInterstitialAd() async {
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
            print('✅ Iklan berhasil dimuat');
          },
          onAdFailedToLoad: (error) {
            _isAdLoaded = false;
            _interstitialAd = null;
            print('❌ Gagal memuat iklan: $error');
          },
        ),
      );
    } catch (e) {
      _isAdLoaded = false;
      print('⚠️ Error loading ad: $e');
    }
  }

  void _setupAdListeners(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('🎬 Iklan mulai ditampilkan');
      },
      onAdDismissedFullScreenContent: (ad) {
        print('✅ Iklan selesai ditutup');
        _isShowingAd = false;
        _isAdLoaded = false;
        _disposeAd();
        // Load iklan berikutnya
        Future.delayed(const Duration(seconds: 1), loadInterstitialAd);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('❌ Gagal menampilkan iklan: $error');
        _isShowingAd = false;
        _isAdLoaded = false;
        _disposeAd();
      },
    );
  }

  Future<void> showInterstitialAd() async {
    if (_isShowingAd) {
      print('⏳ Iklan sedang ditampilkan, skip');
      return;
    }

    if (_isAdLoaded && _interstitialAd != null) {
      try {
        print('🎬 Menampilkan iklan...');
        await _interstitialAd!.show();
      } catch (e) {
        print('⚠️ Error showing ad: $e');
        _isAdLoaded = false;
        _isShowingAd = false;
        _disposeAd();
      }
    } else {
      print('📥 Iklan belum dimuat, loading dulu...');
      await loadInterstitialAd();
      // Tunggu loading selesai
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (_isAdLoaded && !_isShowingAd && _interstitialAd != null) {
        print('🎬 Menampilkan iklan setelah loading...');
        await _interstitialAd!.show();
      } else {
        print('❌ Iklan masih belum siap untuk ditampilkan');
      }
    }
  }

  Future<void> checkAndShowInterstitialAd() async {
    if (checkAndResetSubmitFlag()) {
      print('🚀 Submit berhasil terdeteksi, akan tampilkan iklan...');
      // Tunggu sebentar agar user sempat melihat pesan konfirmasi
      await Future.delayed(const Duration(milliseconds: 500));
      await showInterstitialAd();
    } else {
      print('📊 Tidak ada submit berhasil, skip iklan');
    }
  }

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