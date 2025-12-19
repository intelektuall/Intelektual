import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HalamanHapusIklan extends StatefulWidget {
  const HalamanHapusIklan({super.key});

  @override
  State<HalamanHapusIklan> createState() => _HalamanHapusIklanState();
}

class _HalamanHapusIklanState extends State<HalamanHapusIklan> {
  bool _isPremium = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatusPremium();
  }

  Future<void> _loadStatusPremium() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isPremium = prefs.getBool('is_premium') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', value);
    setState(() => _isPremium = value);
  }

  /// ================== DIALOG PEMBAYARAN ==================
  void _showPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isProcessing = false;
        bool isSuccess = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Faktur Pembayaran"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isProcessing && !isSuccess) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Produk : Premium (Hapus Iklan)"),
                    ),
                    const SizedBox(height: 6),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Harga  : Rp 15.000"),
                    ),
                    const Divider(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Benefit:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("• Tanpa iklan"),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("• Aplikasi lebih nyaman"),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("• Berlaku selamanya"),
                    ),
                  ],

                  if (isProcessing) ...[
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text("Memproses pembayaran..."),
                  ],

                  if (isSuccess) ...[
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 60,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Pembayaran Berhasil!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text("Premium aktif, iklan dihapus 🎉"),
                  ],
                ],
              ),
              actions: [
                if (!isProcessing && !isSuccess)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal"),
                  ),
                if (!isProcessing && !isSuccess)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      setDialogState(() => isProcessing = true);

                      await Future.delayed(const Duration(seconds: 2));
                      await _setPremium(true);

                      setDialogState(() {
                        isProcessing = false;
                        isSuccess = true;
                      });

                      await Future.delayed(const Duration(seconds: 1));
                      if (context.mounted) Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Pembayaran berhasil! Iklan telah dihapus.",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text("Selesaikan Pembayaran"),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  /// ================== BATALKAN PREMIUM ==================
  void _showCancelDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isProcessing = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Batalkan Premium"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isProcessing)
                    const Text(
                      "Apakah kamu yakin ingin membatalkan premium?\n\nIklan akan tampil kembali.",
                    ),
                  if (isProcessing) ...[
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text("Membatalkan langganan..."),
                  ],
                ],
              ),
              actions: [
                if (!isProcessing)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Tidak"),
                  ),
                if (!isProcessing)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      setDialogState(() => isProcessing = true);

                      await Future.delayed(const Duration(seconds: 2));
                      await _setPremium(false);

                      if (context.mounted) Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Premium dibatalkan. Iklan aktif kembali.",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    child: const Text("Ya, Batalkan"),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Premium"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    Icon(
                      Icons.workspace_premium,
                      size: 80,
                      color: Colors.amber,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Premium Access",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Nikmati aplikasi tanpa gangguan iklan",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.block, color: Colors.green),
                      title: Text("Hapus Semua Iklan"),
                    ),
                    ListTile(
                      leading: Icon(Icons.speed, color: Colors.blue),
                      title: Text("Aplikasi Lebih Cepat"),
                    ),
                    ListTile(
                      leading: Icon(Icons.verified, color: Colors.orange),
                      title: Text("Akses Premium Selamanya"),
                    ),
                    Divider(height: 30),
                    Text(
                      "Rp 15.000",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Pembayaran satu kali",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (!_isPremium)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _showPaymentDialog,
                  child: const Text(
                    "Beli Premium",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            else
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check),
                      label: const Text("Premium Aktif"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _showCancelDialog,
                    child: const Text(
                      "Batalkan Langganan",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
