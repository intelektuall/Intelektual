// /Eka/activity/Profile_Page.dart
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animations/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/Eka/activity/Profile_About.dart';
import '/Eka/activity/Profile_Edit.dart';
import '/Eka/activity/Profile_Settings.dart';
import '/Eka/provider/settings_provider.dart';
import '/Eka/provider/profile_stream.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? _pickedImage;
  Uint8List? _profileImageBytes;
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

  // field yang dikelola lewat profile stream
  String pekerjaan = "";
  String alamatRumah = "";
  String hobi = "";
  String status = "";
  String bio = "";

  late ProfileStreamProvider _profileProvider;
  StreamSubscription<Map<String, dynamic>>? _profileSubscription;

  @override
  void initState() {
    super.initState();
    _loadSavedProfileImage();

    _profileProvider = ProfileStreamProvider();
    // inisialisasi stream secara async: load dulu lalu subscribe
    _initProfileStream();
  }

  Future<void> _initProfileStream() async {
    await _profileProvider.loadProfile();
    // listen; stream.multi (di provider) akan langsung mengirim currentData
    _profileSubscription = _profileProvider.stream.listen(
      (data) {
        setState(() {
          pekerjaan = (data["pekerjaan"] ?? pekerjaan) as String;
          alamatRumah = (data["alamatRumah"] ?? alamatRumah) as String;
          hobi = (data["hobi"] ?? hobi) as String;
          status = (data["status"] ?? status) as String;
          bio = (data["bio"] ?? bio) as String;
        });
      },
      onError: (e) {
        debugPrint("Profile stream error: $e");
      },
    );
  }

  @override
  void dispose() {
    try {
      _uploadProgressController?.close();
      _profileSubscription?.cancel();
    } catch (_) {}
    super.dispose();
  }

  /// Muat foto profil Base64 (disimpan terpisah di prefs)
  Future<void> _loadSavedProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final base64String = prefs.getString('profile_image_base64');
      if (base64String != null && base64String.isNotEmpty) {
        setState(() {
          _profileImageBytes = base64Decode(base64String);
        });
      }
    } catch (e) {
      debugPrint("Gagal memuat gambar Base64: $e");
    }
  }

  /// Simpan gambar ke SharedPreferences (Base64)
  Future<void> _saveProfileImageAsBase64(String path) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bytes = await File(path).readAsBytes();
      final base64String = base64Encode(bytes);
      await prefs.setString('profile_image_base64', base64String);
      setState(() {
        _profileImageBytes = bytes;
      });
    } catch (e) {
      debugPrint("Gagal menyimpan gambar Base64: $e");
    }
  }

  /// Simulasi upload (progress bar)
  Future<void> _simulateUpload(String path) async {
    try {
      await _uploadProgressController?.close();
    } catch (_) {}
    _uploadProgressController = StreamController<double>();
    setState(() {
      _isUploading = true;
      _pickedImage = File(path);
    });

    try {
      const int steps = 20;
      for (int i = 1; i <= steps; i++) {
        await Future.delayed(const Duration(milliseconds: 80));
        _uploadProgressController?.add(i / steps);
      }

      await _saveProfileImageAsBase64(path);
    } catch (e) {
      debugPrint("Error saat upload gambar: $e");
    } finally {
      setState(() {
        _isUploading = false;
        _pickedImage = null;
      });
      try {
        await _uploadProgressController?.close();
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
        await _simulateUpload(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error pick image: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $e')));
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
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Hapus Foto Profil'),
              onTap: () async {
                Navigator.of(context).pop();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('profile_image_base64');
                setState(() {
                  _pickedImage = null;
                  _profileImageBytes = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Update data profil via provider
  Future<void> updateEditableData({
    required String newPekerjaan,
    required String newAlamat,
    required String newHobi,
    required String newStatus,
    required String newBio,
  }) async {
    final updatedData = {
      "pekerjaan": newPekerjaan,
      "alamatRumah": newAlamat,
      "hobi": newHobi,
      "status": newStatus,
      "bio": newBio,
    };
    await _profileProvider.updateProfile(updatedData);
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
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeScaleTransition(animation: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );

    // Jika edit mengembalikan result, gunakan itu (tetapi provider sudah menangani penyimpanan)
    if (value == 'edit' && result != null && result is Map) {
      await updateEditableData(
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
          Text(
            value.isNotEmpty ? value : "-",
            style: TextStyle(fontSize: 16, color: valueColor),
          ),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.backgroundMode == "Hitam";

    final backgroundColor = isDarkMode ? Colors.black : Colors.grey[100]!;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.blueGrey;

    Widget avatarWidget() {
      if (_isUploading) {
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
                  CircleAvatar(radius: 50, backgroundColor: Colors.grey[300]),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blueAccent,
                      ),
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
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
        return SizedBox(
          width: 100,
          height: 100,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: CircleAvatar(
              key: ValueKey<String>(
                _profileImageBytes != null ? 'custom_image' : 'default_avatar',
              ),
              radius: 50,
              backgroundImage: _profileImageBytes != null
                  ? MemoryImage(_profileImageBytes!)
                  : const AssetImage('assets/images/1.png') as ImageProvider,
              backgroundColor: Colors.white,
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Profile Page",
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onSelected: handleMenuSelection,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit Info Tambahan')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'about', child: Text('About Us')),
            ],
          ),
        ],
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
    );
  }
}
