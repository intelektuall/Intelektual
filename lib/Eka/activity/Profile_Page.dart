import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart';

import '/Eka/provider/settings_provider.dart';
import '/Eka/activity/Profile_Edit.dart';
import '/Eka/activity/Profile_Settings.dart';
import '/Eka/activity/Profile_About.dart';
import '/Eka/provider/firestore_service.dart';
import '/Eka/provider/firebase_helper.dart';
import '/Eka/provider/permission_helper.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  File? _localImageFile;
  String? _base64Image;
  Map<String, dynamic> currentData = {};

  @override
  void initState() {
    super.initState();
    FirebaseAnalyticsHelper.setCurrentScreen(screenName: 'Profile_Page');
    _loadLocalImage();
  }

  Future<void> _loadLocalImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final localFile = File(p.join(dir.path, 'profile_image.jpg'));
    if (await localFile.exists()) {
      setState(() => _localImageFile = localFile);
    }
  }

  Future<void> _saveLocalImage(File image) async {
    final dir = await getApplicationDocumentsDirectory();
    final localFile = File(p.join(dir.path, 'profile_image.jpg'));
    await image.copy(localFile.path);
    setState(() => _localImageFile = localFile);
  }

  Future<void> _pickImage(ImageSource source) async {
    bool granted = false;
    if (source == ImageSource.camera) {
      granted = await PermissionHelper.requestCamera(context);
    } else {
      granted = await PermissionHelper.requestGallery(context);
    }

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Akses ditolak. Tidak dapat membuka fitur.'),
        ),
      );
      return;
    }

    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked == null) return;

      setState(() => _isUploading = true);
      final file = File(picked.path);
      await _saveLocalImage(file);

      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      await FirestoreService().saveProfileData({
        'profileImageBase64': base64String,
      });

      setState(() {
        _base64Image = base64String;
        _isUploading = false;
      });

      FirebaseAnalyticsHelper.logEvent(name: 'profile_image_uploaded');
    } catch (e) {
      debugPrint("Upload error: $e");
      setState(() => _isUploading = false);
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Buka Kamera'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Pilih dari Galeri'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Hapus Foto Profil'),
            onTap: () async {
              Navigator.pop(context);
              final dir = await getApplicationDocumentsDirectory();
              final localFile = File(p.join(dir.path, 'profile_image.jpg'));
              if (await localFile.exists()) await localFile.delete();
              await FirestoreService().saveProfileData({
                'profileImageBase64': '',
              });
              setState(() {
                _localImageFile = null;
                _base64Image = null;
              });
              FirebaseAnalyticsHelper.logEvent(name: 'profile_image_deleted');
            },
          ),
        ],
      ),
    );
  }

  void handleMenuSelection(String value) async {
    debugPrint("Navigasi ke halaman $value ...");
    if (!mounted) return;

    if (currentData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data profil belum dimuat.")),
      );
      return;
    }

    Widget page = const SizedBox(); // default aman

    if (value == 'edit') {
      // 🔹 Konversi data hobi (List → String)
      String hobiValue = "";
      if (currentData['hobi'] is List) {
        hobiValue = (currentData['hobi'] as List).join(", ");
      } else if (currentData['hobi'] is String) {
        hobiValue = currentData['hobi'];
      }

      page = ProfileEdit(
        pekerjaan: currentData['pekerjaan'] ?? '',
        alamatRumah: currentData['alamatRumah'] ?? '',
        hobi: hobiValue,
        status: currentData['statusPernikahan'] ?? '',
        bio: currentData['bio'] ?? '',
      );
    } else if (value == 'settings') {
      page = const ProfileSettings();
    } else if (value == 'about') {
      page = const ProfileAbout();
    }

    // 🔹 Gunakan animasi FadeScale agar sesuai dengan struktur awal
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeScaleTransition(animation: anim, child: child),
      ),
    );
  }

  Widget buildInfoTile(
    String label,
    String value, {
    Color? labelColor,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: labelColor, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value : "-",
            style: TextStyle(color: valueColor, fontSize: 16),
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Profile Page", style: TextStyle(color: textColor)),
        actions: [
          PopupMenuButton<String>(
            onSelected: handleMenuSelection,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit Profil')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'about', child: Text('About Us')),
            ],
          ),
        ],
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: FirestoreService().getProfileStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat profil"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          currentData = snapshot.data!;
          final base64Image = currentData['profileImageBase64'];

          ImageProvider imageProvider;
          if (_localImageFile != null) {
            imageProvider = FileImage(_localImageFile!);
          } else if (base64Image != null && base64Image.isNotEmpty) {
            imageProvider =
                MemoryImage(base64Decode(base64Image)) as ImageProvider;
          } else {
            imageProvider = const AssetImage('assets/images/1.png');
          }

          // 🔹 Ambil semua data Firestore
          final nama = currentData['nama'] ?? '';
          final email = currentData['email'] ?? '';
          final nomorHP = currentData['nomorHP'] ?? '';
          final jenisKelamin = currentData['jenisKelamin'] ?? '';
          final umur = currentData['umur'] ?? '';
          final ttl = currentData['tempatTanggalLahir'] ?? '';
          final pekerjaan = currentData['pekerjaan'] ?? '';
          final alamatRumah = currentData['alamatRumah'] ?? '';
          final hobi = currentData['hobi'] ?? '';
          final statusPernikahan = currentData['statusPernikahan'] ?? '';
          final bio = currentData['bio'] ?? '';

          String hobiText = "-";
          if (hobi != null) {
            if (hobi is List && hobi.isNotEmpty) {
              hobiText = hobi.join(", ");
            } else if (hobi is String && hobi.isNotEmpty) {
              hobiText = hobi;
            }
          }

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: imageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
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
                            nama,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(email, style: TextStyle(color: subTextColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              buildInfoTile(
                "Nomor HP",
                nomorHP,
                labelColor: subTextColor,
                valueColor: textColor,
              ),
              buildInfoTile(
                "Jenis Kelamin",
                jenisKelamin,
                labelColor: subTextColor,
                valueColor: textColor,
              ),
              buildInfoTile(
                "Umur",
                umur,
                labelColor: subTextColor,
                valueColor: textColor,
              ),
              buildInfoTile(
                "Tempat/Tanggal Lahir",
                ttl,
                labelColor: subTextColor,
                valueColor: textColor,
              ),
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
              buildInfoTile(
                "Pekerjaan",
                pekerjaan,
                labelColor: subTextColor,
                valueColor: textColor,
              ),
              buildInfoTile(
                "Alamat Rumah",
                alamatRumah,
                labelColor: subTextColor,
                valueColor: textColor,
              ),
              buildInfoTile(
                "Hobi",
                hobiText,
                labelColor: subTextColor,
                valueColor: textColor,
              ),
              buildInfoTile(
                "Status Pernikahan",
                statusPernikahan,
                labelColor: subTextColor,
                valueColor: textColor,
              ),
              buildInfoTile(
                "Bio",
                bio,
                labelColor: subTextColor,
                valueColor: textColor,
              ),
            ],
          );
        },
      ),
    );
  }
}
