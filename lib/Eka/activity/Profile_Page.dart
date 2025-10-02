// Eka/activity/Profile_Page.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animations/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/Eka/activity/Profile_About.dart';
import '/Eka/activity/Profile_Edit.dart';
import '/Eka/activity/Profile_Settings.dart';
import '/Eka/provider/settings_provider.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? _pickedImage;       // foto yang sudah final & tampil
  File? _pendingImage;      // foto sementara saat upload
  final ImagePicker _picker = ImagePicker();

  StreamController<double>? _uploadProgressController;
  bool _isUploading = false;

  // contoh data profil (non-sensitive)
  String name = "Ultraman Nex";
  String gender = "Laki-laki";
  String umur = "300 Tahun";
  String ttl = "Planet Mars, 20 Oktober";
  String email = "ultramannex@gmail.com";
  String nohp = "+62 821-6679-7788";
  String pekerjaan = "Penjaga Galaksi";
  String alamatRumah = "Base Alpha, Mars";
  String hobi = "Berlatih bela diri";
  String status = "Single";
  String bio = "Ultraman dari masa depan. Penyuka keadilan dan cahaya.";

  @override
  void initState() {
    super.initState();
    _loadSavedProfileImage();
  }

  @override
  void dispose() {
    // Tutup controller bila perlu
    try {
      if (_uploadProgressController != null && !_uploadProgressController!.isClosed) {
        _uploadProgressController!.close();
      }
    } catch (e) {
      // ignore
    }
    super.dispose();
  }

  Future<void> _loadSavedProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString('profile_image_path');
      if (path != null && path.isNotEmpty) {
        setState(() {
          _pickedImage = File(path);
        });
      }
    } catch (e) {
      debugPrint("Gagal load image path: $e");
    }
  }

  Future<void> _saveProfileImagePath(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', path);
    } catch (e) {
      debugPrint("Gagal save image path: $e");
    }
  }

  // Simulasi upload yang mengirim progress lewat Stream
  Future<void> _simulateUpload(String path) async {
    // tutup controller lama kalau ada
    try {
      if (_uploadProgressController != null && !_uploadProgressController!.isClosed) {
        await _uploadProgressController!.close();
      }
    } catch (_) {}

    _uploadProgressController = StreamController<double>();
    setState(() {
      _isUploading = true;
      _pendingImage = File(path); // tahan dulu
    });

    try {
      const int steps = 20; // 20 langkah -> durasi ~2 detik
      for (int i = 1; i <= steps; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (_uploadProgressController != null && !_uploadProgressController!.isClosed) {
          _uploadProgressController!.add(i / steps);
        }
      }

      // Simulasi upload selesai: simpan & pindahkan pending -> picked
      await _saveProfileImagePath(path);

      setState(() {
        _pickedImage = _pendingImage;
        _pendingImage = null;
        _isUploading = false;
      });
    } catch (e) {
      debugPrint("Error saat simulasi upload: $e");
      // pada error, batalkan state upload
      setState(() {
        _pendingImage = null;
        _isUploading = false;
      });
    } finally {
      // tutup controller di akhirnya
      try {
        if (_uploadProgressController != null && !_uploadProgressController!.isClosed) {
          await _uploadProgressController!.close();
        }
      } catch (_) {}
      _uploadProgressController = null;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        // jangan set _pickedImage langsung — kita pakai pending & tunggu upload selesai
        await _simulateUpload(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error pick image: $e");
      // kamu bisa tampilkan SnackBar atau dialog kalau mau
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: $e')),
        );
      }
    }
  }

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Buka Kamera'),
              onTap: () async {
                Navigator.of(context).pop();
                await _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                Navigator.of(context).pop();
                await _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Hapus Foto Profil'),
              onTap: () async {
                Navigator.of(context).pop();
                try {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('profile_image_path');
                } catch (e) {
                  debugPrint("Gagal remove prefs: $e");
                }
                setState(() {
                  _pickedImage = null;
                  _pendingImage = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void updateEditableData({
    required String newPekerjaan,
    required String newAlamat,
    required String newHobi,
    required String newStatus,
    required String newBio,
  }) {
    setState(() {
      pekerjaan = newPekerjaan;
      alamatRumah = newAlamat;
      hobi = newHobi;
      status = newStatus;
      bio = newBio;
    });
  }

  void handleMenuSelection(String value) async {
    Widget page;
    if (value == 'edit') {
      page = ProfileEdit(
        pekerjaan: pekerjaan,
        alamatRumah: alamatRumah,
        hobi: hobi,
        status: status,
        bio: bio,
      );
    } else if (value == 'settings') {
      page = const ProfileSettings();
    } else {
      page = const ProfileAbout();
    }

    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeScaleTransition(animation: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );

    if (value == 'edit' && result != null && result is Map) {
      updateEditableData(
        newPekerjaan: result['pekerjaan'] ?? pekerjaan,
        newAlamat: result['alamatRumah'] ?? alamatRumah,
        newHobi: result['hobi'] ?? hobi,
        newStatus: result['status'] ?? status,
        newBio: result['bio'] ?? bio,
      );
    }
  }

  Widget buildInfoTile(
    String label,
    String value,
    Color labelColor,
    Color valueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: labelColor)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, color: valueColor)),
          const Divider(),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Kembali ke halaman sebelumnya?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.backgroundMode == "Hitam";

    final backgroundColor = isDarkMode ? Colors.black : Colors.grey[100]!;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.blueGrey;

    // Widget avatar: kalau sedang uploading -> tampilkan persentase,
    // kalau tidak -> tampilkan foto (dengan AnimatedSwitcher untuk fade)
    Widget avatarWidget() {
      if (_isUploading) {
        // Pastikan ada stream. Jika controller null (edge-case), tampil 0%
        final stream = _uploadProgressController?.stream;
        return StreamBuilder<double>(
          stream: stream,
          builder: (context, snapshot) {
            final progress = (snapshot.data ?? 0.0).clamp(0.0, 1.0);
            final percent = (progress * 100).toInt();
            return SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // lingkaran dasar abu-abu
                  CircleAvatar(radius: 50, backgroundColor: Colors.grey[300]),
                  // lingkaran progress (di belakang teks)
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                  // persentase teks
                  Text(
                    "$percent%",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        // Tampilkan foto (default asset kalau null)
        return SizedBox(
          width: 100,
          height: 100,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: CircleAvatar(
              key: ValueKey<String>(_pickedImage?.path ?? 'default_avatar'),
              radius: 50,
              backgroundImage: _pickedImage != null
                  ? FileImage(_pickedImage!)
                  : const AssetImage('assets/images/1.png') as ImageProvider,
              backgroundColor: Colors.white,
            ),
          ),
        );
      }
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          automaticallyImplyLeading: false,
          title: Text(
            "Profile Page",
            style: TextStyle(
              fontSize: 20,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            Tooltip(
              message: "Menu lainnya",
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onSelected: handleMenuSelection,
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Info Tambahan'),
                  ),
                  PopupMenuItem(value: 'settings', child: Text('Settings')),
                  PopupMenuItem(value: 'about', child: Text('About Us')),
                ],
              ),
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop) Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      avatarWidget(),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: _showImagePickerOptions,
                          child: Tooltip(
                            message: "Ubah foto profil",
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.blueAccent,
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: TextStyle(fontSize: 14, color: subTextColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),
            buildInfoTile("Nomor HP", nohp, subTextColor, textColor),
            buildInfoTile("Jenis Kelamin", gender, subTextColor, textColor),
            buildInfoTile("Umur", umur, subTextColor, textColor),
            buildInfoTile("Tempat/Tanggal Lahir", ttl, subTextColor, textColor),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Informasi Tambahan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            buildInfoTile("Pekerjaan", pekerjaan, subTextColor, textColor),
            buildInfoTile("Alamat Rumah", alamatRumah, subTextColor, textColor),
            buildInfoTile("Hobi", hobi, subTextColor, textColor),
            buildInfoTile("Status Pernikahan", status, subTextColor, textColor),
            buildInfoTile("Bio", bio, subTextColor, textColor),
          ],
        ),
      ),
    );
  }
}
