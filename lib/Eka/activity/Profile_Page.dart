import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animations/animations.dart';
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
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Buka Kamera'),
                  onTap: () async {
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _pickedImage = File(pickedFile.path);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pilih dari Galeri'),
                  onTap: () async {
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _pickedImage = File(pickedFile.path);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
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

    if (value == 'edit' && result != null) {
      updateEditableData(
        newPekerjaan: result['pekerjaan'],
        newAlamat: result['alamatRumah'],
        newHobi: result['hobi'],
        newStatus: result['status'],
        newBio: result['bio'],
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
              itemBuilder:
                  (context) => const [
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
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _pickedImage != null
                              ? FileImage(_pickedImage!)
                              : const AssetImage('assets/images/1.png')
                                  as ImageProvider,
                      backgroundColor: Colors.white,
                    ),
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
    );
  }
}
