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
import '/Eka/provider/firebase_helper.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? _pickedImage;
  Uint8List? _profileImageBytes;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  String name = "Ultraman Nex";
  String gender = "Laki-laki";
  String umur = "300 Tahun";
  String ttl = "Planet Mars, 20 Oktober";
  String email = "ultramannex@gmail.com";
  String nohp = "+62 821-6679-7788";

  String pekerjaan = "";
  String alamatRumah = "";
  String hobi = "";
  String status = "";
  String bio = "";

  late ProfileStreamProvider _profileProvider;
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();

    // Log pembukaan halaman profil
    FirebaseAnalyticsHelper.setCurrentScreen(screenName: 'Profile_Page');
    FirebaseAnalyticsHelper.logEvent(name: 'open_profile_page');

    _loadSavedProfileImage();
    _profileProvider = ProfileStreamProvider();
    _profileFuture = _loadProfileOnce();
  }

  Future<Map<String, dynamic>> _loadProfileOnce() async {
    await Future.delayed(const Duration(milliseconds: 600));
    await _profileProvider.loadProfile();
    final map = await _profileProvider.getProfileOnce();

    FirebaseAnalyticsHelper.logEvent(name: 'profile_loaded', parameters: {
      'has_extra_info': map.isNotEmpty,
    });

    return map;
  }

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

  Future<void> _simulateUpload(String path) async {
    setState(() {
      _isUploading = true;
      _pickedImage = File(path);
    });

    const int steps = 20;
    for (int i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
    }

    await _saveProfileImageAsBase64(path);

    setState(() {
      _isUploading = false;
      _pickedImage = null;
    });

    FirebaseAnalyticsHelper.logEvent(
      name: 'profile_image_upload_complete',
      parameters: {'method': 'simulated'},
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile =
          await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        FirebaseAnalyticsHelper.logEvent(
          name: 'profile_image_selected',
          parameters: {'source': source.name},
        );
        await _simulateUpload(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error pick image: $e");
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
                FirebaseAnalyticsHelper.logEvent(
                  name: 'profile_image_deleted',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

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
    setState(() {
      pekerjaan = newPekerjaan;
      alamatRumah = newAlamat;
      hobi = newHobi;
      status = newStatus;
      bio = newBio;
    });

    FirebaseAnalyticsHelper.logEvent(
      name: 'profile_additional_updated',
      parameters: {
        'pekerjaan_set': newPekerjaan.isNotEmpty,
        'alamat_set': newAlamat.isNotEmpty,
        'hobi_set': newHobi.isNotEmpty,
      },
    );
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
      FirebaseAnalyticsHelper.logEvent(name: 'open_profile_edit');
    } else if (value == 'settings') {
      page = const ProfileSettings();
      FirebaseAnalyticsHelper.logEvent(name: 'open_profile_settings');
    } else {
      page = const ProfileAbout();
      FirebaseAnalyticsHelper.logEvent(name: 'open_profile_about');
    }

    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeScaleTransition(animation: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );

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
      String label, String value, Color labelColor, Color valueColor) {
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
            icon: Icon(Icons.more_vert,
                color: isDarkMode ? Colors.white : Colors.black),
            onSelected: handleMenuSelection,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit Info Tambahan')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'about', child: Text('About Us')),
            ],
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: FutureBuilder<Map<String, dynamic>>(
          key: ValueKey(_profileFuture),
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Gagal memuat profil"));
            }

            final data = snapshot.data ?? {};
            pekerjaan = data["pekerjaan"] ?? pekerjaan;
            alamatRumah = data["alamatRumah"] ?? alamatRumah;
            hobi = data["hobi"] ?? hobi;
            status = data["status"] ?? status;
            bio = data["bio"] ?? bio;

            return ListView(
              key: const ValueKey("profileLoaded"),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _profileImageBytes != null
                                  ? MemoryImage(_profileImageBytes!)
                                  : const AssetImage('assets/images/1.png')
                                      as ImageProvider,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: _showImagePickerOptions,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.blueAccent,
                                child: const Icon(Icons.edit,
                                    size: 16, color: Colors.white),
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
                            Text(name,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            const SizedBox(height: 4),
                            Text(email,
                                style: TextStyle(
                                    fontSize: 14, color: subTextColor)),
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
                  child: Text("Informasi Tambahan",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor)),
                ),
                const SizedBox(height: 8),
                buildInfoTile("Pekerjaan", pekerjaan, subTextColor, textColor),
                buildInfoTile("Alamat Rumah", alamatRumah, subTextColor, textColor),
                buildInfoTile("Hobi", hobi, subTextColor, textColor),
                buildInfoTile("Status Pernikahan", status, subTextColor, textColor),
                buildInfoTile("Bio", bio, subTextColor, textColor),
              ],
            );
          },
        ),
      ),
    );
  }
}
