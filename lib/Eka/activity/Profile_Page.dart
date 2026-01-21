import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // ✅ FIX UTAMA
import 'package:image_picker/image_picker.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import '/Eka/provider/settings_provider.dart';
import '/Eka/activity/Profile_Edit.dart';
import '/Eka/activity/Profile_Settings.dart';
import '/Eka/activity/Profile_About.dart';

import '/Eka/provider/firestore_service.dart';
import '/Eka/provider/firestore_service_base.dart';
import '/Eka/provider/firebase_helper.dart';
import '/Eka/provider/permission_helper.dart';

import '/Periklanan/HalamanHapusIklan.dart';
import '/Fauzan/LoginPage/login_screen.dart';

// 🔑 FIX UTAMA: FLAG KHUSUS INTEGRATION TEST
const bool isIntegrationTest = bool.fromEnvironment(
  'INTEGRATION_TEST',
  defaultValue: false,
);

class MyProfile extends StatefulWidget {
  final FirestoreServiceBase firestore;

  MyProfile({super.key, FirestoreServiceBase? firestore})
    : firestore = firestore ?? FirestoreService();

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final ImagePicker _picker = ImagePicker();
  File? _localImageFile;
  bool _isUploading = false;

  Map<String, dynamic> currentData = {};

  @override
  void initState() {
    super.initState();
    FirebaseAnalyticsHelper.setCurrentScreen(screenName: 'Profile_Page');
    _loadLocalImage();
  }

  // ================= LOCAL IMAGE =================
  Future<void> _loadLocalImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'profile_image.jpg'));
    if (await file.exists()) {
      setState(() => _localImageFile = file);
    }
  }

  Future<void> _saveLocalImage(File image) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'profile_image.jpg'));
    await image.copy(file.path);
    setState(() => _localImageFile = file);
  }

  // ================= PERMISSION DIALOG =================
  Future<bool> _showPermissionReasonDialog({
    required String title,
    required String message,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Lanjutkan"),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ================= PICK IMAGE =================
  Future<void> _pickImage(ImageSource source) async {
    bool granted = false;

    if (source == ImageSource.camera) {
      final status = await Permission.camera.status;
      if (status.isGranted) {
        granted = true;
      } else {
        final allow = await _showPermissionReasonDialog(
          title: "Izin Kamera",
          message:
              "Aplikasi memerlukan akses kamera untuk mengambil foto profil.",
        );
        if (!allow) return;
        granted = await PermissionHelper.requestCamera(context);
      }
    } else {
      final status = await Permission.photos.status;
      if (status.isGranted) {
        granted = true;
      } else {
        final allow = await _showPermissionReasonDialog(
          title: "Izin Galeri",
          message:
              "Aplikasi memerlukan akses galeri untuk memilih foto profil.",
        );
        if (!allow) return;
        granted = await PermissionHelper.requestGallery(context);
      }
    }

    if (!granted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Akses ditolak")));
      return;
    }

    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked == null) return;

      setState(() => _isUploading = true);

      final file = File(picked.path);
      await _saveLocalImage(file);

      final base64Image = base64Encode(await file.readAsBytes());
      await widget.firestore.saveProfileData({
        'profileImageBase64': base64Image,
      });

      FirebaseAnalyticsHelper.logEvent(name: 'profile_image_uploaded');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  // ================= BOTTOM SHEET =================
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Buka Kamera"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Pilih dari Galeri"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text("Hapus Foto Profil"),
            onTap: () async {
              Navigator.pop(context);
              final dir = await getApplicationDocumentsDirectory();
              final file = File(p.join(dir.path, 'profile_image.jpg'));
              if (await file.exists()) await file.delete();

              await widget.firestore.saveProfileData({
                'profileImageBase64': '',
              });

              setState(() => _localImageFile = null);
            },
          ),
        ],
      ),
    );
  }

  // ================= MENU HANDLER =================
  Future<void> _handleMenuSelection(String value) async {
    if (currentData.isEmpty) return;

    Widget page;

    if (value == 'edit') {
      final hobi = (currentData['hobi'] is List)
          ? (currentData['hobi'] as List).join(', ')
          : currentData['hobi'] ?? '';

      page = ProfileEdit(
        firestore: widget.firestore,
        pekerjaan: currentData['pekerjaan'] ?? '',
        alamatRumah: currentData['alamatRumah'] ?? '',
        hobi: hobi,
        status: currentData['statusPernikahan'] ?? '',
        bio: currentData['bio'] ?? '',
      );
    } else if (value == 'settings') {
      page = const ProfileSettings();
    } else {
      page = const ProfileAbout();
    }

    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeScaleTransition(animation: anim, child: child),
      ),
    );
  }

  // ================= INFO TILE =================
  Widget buildInfoTile(
    String label,
    String value,
    Color labelColor,
    Color valueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: labelColor)),
          const SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value : "-",
            style: TextStyle(color: valueColor),
          ),
          const Divider(),
        ],
      ),
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.backgroundMode == "Hitam";

    final bg = isDark ? Colors.black : Colors.grey[100]!;
    final text = isDark ? Colors.white : Colors.black87;
    final sub = isDark ? Colors.grey[400]! : Colors.blueGrey;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Profile Page", style: TextStyle(color: text)),
        actions: [
          IconButton(
            tooltip: "Hapus Iklan",
            icon: Image.asset('assets/icons/remove_ads.png', width: 60),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HalamanHapusIklan()),
              );
            },
          ),

          // 🔑 POPUP MENU (PRODUCTION)
          PopupMenuButton<String>(
            key: const Key('profile_menu'),
            onSelected: _handleMenuSelection,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit Profil')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'about', child: Text('About Us')),
            ],
          ),

          // 🧪 TEST-ONLY BUTTON (DEBUG & TEST MODE)
          if (isIntegrationTest)
            IconButton(
              key: const Key('test_edit_profile'),
              icon: const Icon(Icons.edit),
              onPressed: () => _handleMenuSelection('edit'),
            ),
        ],
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: widget.firestore.getProfileStream(),
        initialData: const {},
        builder: (context, snap) {
          final data = snap.data ?? {};

          if (data.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          currentData = data;
          final base64 = data['profileImageBase64'];

          ImageProvider avatar;
          if (_localImageFile != null) {
            avatar = FileImage(_localImageFile!);
          } else if (base64 != null && base64.isNotEmpty) {
            avatar = MemoryImage(base64Decode(base64));
          } else {
            avatar = const AssetImage('assets/images/1.png');
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
                        CircleAvatar(radius: 50, backgroundImage: avatar),
                        GestureDetector(
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
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['nama'] ?? '',
                          style: TextStyle(color: text, fontSize: 20),
                        ),
                        Text(data['email'] ?? '', style: TextStyle(color: sub)),
                      ],
                    ),
                  ],
                ),
              ),
              buildInfoTile("Nomor HP", data['nomorHP'] ?? '', sub, text),
              buildInfoTile(
                "Jenis Kelamin",
                data['jenisKelamin'] ?? '',
                sub,
                text,
              ),
              buildInfoTile("Umur", data['umur'] ?? '', sub, text),
              buildInfoTile("TTL", data['tempatTanggalLahir'] ?? '', sub, text),
              const SizedBox(height: 12),
              buildInfoTile("Pekerjaan", data['pekerjaan'] ?? '', sub, text),
              buildInfoTile(
                "Alamat Rumah",
                data['alamatRumah'] ?? '',
                sub,
                text,
              ),
              buildInfoTile(
                "Hobi",
                (data['hobi'] is List)
                    ? (data['hobi'] as List).join(', ')
                    : data['hobi'] ?? '',
                sub,
                text,
              ),
              buildInfoTile(
                "Status Pernikahan",
                data['statusPernikahan'] ?? '',
                sub,
                text,
              ),
              buildInfoTile("Bio", data['bio'] ?? '', sub, text),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  key: const Key('btn_logout'),
                  icon: const Icon(Icons.logout, color: Colors.black),
                  label: const Text(
                    "Log Out",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyLoginAndSignin(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
