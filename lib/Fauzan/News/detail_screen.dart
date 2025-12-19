import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String imageUrl;
  final String headline;
  final String newsbody;
  final String synopsis;
  final DateTime date;

  const DetailScreen({
    super.key,
    required this.imageUrl,
    required this.headline,
    required this.newsbody,
    required this.synopsis,
    required this.date,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isBookmarked = false;
  bool _isLoading = true;

  /// 🔑 PREMIUM
  bool _isPremium = false;

  /// ADS
  BannerAd? _bannerAd;
  bool _isBannerReady = false;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    await _loadPremiumStatus();

    // hanya load iklan jika belum premium
    if (!_isPremium) {
      _loadBannerAd();
    }

    // loading palsu
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isPremium = prefs.getBool('is_premium') ?? false;
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _showShareOptions(BuildContext context) {
    final shareOptions = [
      {'icon': Icons.bluetooth, 'label': 'Bluetooth'},
      {'icon': Icons.call, 'label': 'Whatsapp'},
      {'icon': Icons.telegram, 'label': 'Telegram'},
      {'icon': Icons.facebook, 'label': 'Facebook'},
      {'icon': Icons.camera_alt, 'label': 'Instagram'},
      {'icon': Icons.email, 'label': 'Gmail'},
      {'icon': Icons.sms, 'label': 'SMS'},
      {'icon': Icons.link, 'label': 'Salin Link'},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Bagikan ke...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: shareOptions.map((option) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        final label = option['label'];
                        final message = label == 'Salin Link'
                            ? 'Link disalin'
                            : 'Berbagi melalui $label...';
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            child: Icon(option['icon'] as IconData),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            option['label'] as String,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.headline),
        backgroundColor: Colors.blueAccent,
        actions: [
          if (_isPremium)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.workspace_premium, color: Colors.amber),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: (!_isPremium && _isBannerReady)
                          ? _bannerAd!.size.height.toDouble()
                          : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          widget.imageUrl,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.headline,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tanggal: ${DateFormat('dd MMM yyyy').format(widget.date)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Tooltip(
                                    message: isBookmarked ? "Unsaved" : "Save",
                                    child: IconButton(
                                      icon: Icon(
                                        isBookmarked
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isBookmarked = !isBookmarked;
                                        });
                                      },
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Share",
                                    child: IconButton(
                                      icon: const Icon(Icons.share),
                                      onPressed: () =>
                                          _showShareOptions(context),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widget.newsbody
                                    .split("\n\n")
                                    .map(
                                      (p) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: Text(
                                          p,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          /// 🔻 IKLAN HANYA JIKA BELUM PREMIUM
          if (!_isPremium && _isBannerReady)
            SafeArea(
              child: SizedBox(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-3940256099942544/6300978111", // TEST ID
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }
}
