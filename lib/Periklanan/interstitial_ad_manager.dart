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
  }

  static bool checkAndResetSubmitFlag() {
    final result = _submitSuccessful;
    _submitSuccessful = false;
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
          },
          onAdFailedToLoad: (error) {
            _isAdLoaded = false;
            _interstitialAd = null;
          },
        ),
      );
    } catch (e) {
      _isAdLoaded = false;
    }
  }

  void _setupAdListeners(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        _isAdLoaded = false;
        _disposeAd();
        Future.delayed(const Duration(seconds: 1), loadInterstitialAd);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        _isAdLoaded = false;
        _disposeAd();
      },
    );
  }

  Future<void> showInterstitialAd() async {
    if (_isShowingAd) return;

    if (_isAdLoaded && _interstitialAd != null) {
      try {
        await _interstitialAd!.show();
      } catch (e) {
        _isAdLoaded = false;
        _isShowingAd = false;
        _disposeAd();
      }
    } else {
      await loadInterstitialAd();
      Future.delayed(const Duration(milliseconds: 800), () {
        if (_isAdLoaded && !_isShowingAd) {
          _interstitialAd?.show();
        }
      });
    }
  }

  Future<void> checkAndShowInterstitialAd() async {
    if (checkAndResetSubmitFlag()) {
      await Future.delayed(const Duration(milliseconds: 500));
      await showInterstitialAd();
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