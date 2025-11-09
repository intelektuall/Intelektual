// // /Eka/activity/Profile_Page.dart : Sebelum ada firestore ganteng punya eka
// import 'dart:io';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:animations/animations.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '/Eka/activity/Profile_About.dart';
// import '/Eka/activity/Profile_Edit.dart';
// import '/Eka/activity/Profile_Settings.dart';
// import '/Eka/provider/settings_provider.dart';
// import '/Eka/provider/profile_stream.dart';
// import '/Eka/provider/firebase_helper.dart';
// import '/Eka/provider/profile_stream_controller.dart';

// class MyProfile extends StatefulWidget {
//   const MyProfile({super.key});

//   @override
//   State<MyProfile> createState() => _MyProfileState();
// }

// class _MyProfileState extends State<MyProfile> {
//   File? _pickedImage;
//   Uint8List? _profileImageBytes;
//   final ImagePicker _picker = ImagePicker();
//   bool _isUploading = false;

//   String name = "Ultraman Nex";
//   String gender = "Laki-laki";
//   String umur = "300 Tahun";
//   String ttl = "Planet Mars, 20 Oktober";
//   String email = "ultramannex@gmail.com";
//   String nohp = "+62 821-6679-7788";

//   Map<String, dynamic> currentData = {};
//   late ProfileStreamProvider _profileProvider;

//   @override
//   void initState() {
//     super.initState();

//     FirebaseAnalyticsHelper.setCurrentScreen(screenName: 'Profile_Page');
//     FirebaseAnalyticsHelper.logEvent(name: 'open_profile_page');

//     _loadSavedProfileImage();
//     _profileProvider = ProfileStreamProvider();
//     _profileProvider.loadProfile(); // muat data awal dan kirim ke stream
//   }

//   Future<void> _loadSavedProfileImage() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final base64String = prefs.getString('profile_image_base64');
//       if (base64String != null && base64String.isNotEmpty) {
//         setState(() {
//           _profileImageBytes = base64Decode(base64String);
//         });
//       }
//     } catch (e) {
//       debugPrint("Gagal memuat gambar Base64: $e");
//     }
//   }

//   Future<void> _saveProfileImageAsBase64(String path) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final bytes = await File(path).readAsBytes();
//       final base64String = base64Encode(bytes);
//       await prefs.setString('profile_image_base64', base64String);
//       setState(() {
//         _profileImageBytes = bytes;
//       });
//       FirebaseAnalyticsHelper.logEvent(
//         name: 'profile_image_saved',
//         parameters: {'success': true},
//       );
//     } catch (e) {
//       debugPrint("Gagal menyimpan gambar Base64: $e");
//     }
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final pickedFile =
//           await _picker.pickImage(source: source, imageQuality: 80);
//       if (pickedFile != null) {
//         setState(() {
//           _isUploading = true;
//           _pickedImage = File(pickedFile.path);
//         });

//         // proses simpan (asynchronous nyata: baca file dan simpan ke prefs)
//         await _saveProfileImageAsBase64(pickedFile.path);

//         setState(() {
//           _isUploading = false;
//           _pickedImage = null;
//         });

//         FirebaseAnalyticsHelper.logEvent(
//           name: 'profile_image_selected',
//           parameters: {'source': source.name},
//         );
//       }
//     } catch (e) {
//       debugPrint("Error pick image: $e");
//     }
//   }

//   Future<void> _showImagePickerOptions() async {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Buka Kamera'),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Pilih dari Galeri'),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete_outline),
//               title: const Text('Hapus Foto Profil'),
//               onTap: () async {
//                 Navigator.of(context).pop();
//                 final prefs = await SharedPreferences.getInstance();
//                 await prefs.remove('profile_image_base64');
//                 setState(() {
//                   _pickedImage = null;
//                   _profileImageBytes = null;
//                 });
//                 FirebaseAnalyticsHelper.logEvent(
//                   name: 'profile_image_deleted',
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _applyUpdatedData(Map<String, dynamic> newData) async {
//     // kirim ke provider (provider akan menyimpan ke prefs + broadcast stream)
//     await _profileProvider.updateProfile(newData);
//     FirebaseAnalyticsHelper.logEvent(
//       name: 'profile_additional_updated',
//       parameters: {'updated_keys': newData.keys.join(',')},
//     );
//   }

//   void handleMenuSelection(String value) async {
//     Widget page;
//     if (value == 'edit') {
//       // pakai data terbaru dari currentData jika ada
//       page = ProfileEdit(
//         pekerjaan: currentData['pekerjaan'] ?? '',
//         alamatRumah: currentData['alamatRumah'] ?? '',
//         hobi: currentData['hobi'] ?? '',
//         status: currentData['status'] ?? '',
//         bio: currentData['bio'] ?? '',
//       );
//       FirebaseAnalyticsHelper.logEvent(name: 'open_profile_edit');
//     } else if (value == 'settings') {
//       page = const ProfileSettings();
//       FirebaseAnalyticsHelper.logEvent(name: 'open_profile_settings');
//     } else {
//       page = const ProfileAbout();
//       FirebaseAnalyticsHelper.logEvent(name: 'open_profile_about');
//     }

//     final result = await Navigator.of(context).push(
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => page,
//         transitionsBuilder: (context, animation, secondaryAnimation, child) =>
//             FadeScaleTransition(animation: animation, child: child),
//         transitionDuration: const Duration(milliseconds: 400),
//       ),
//     );

//     // Perbaikan tipe result: cek result is Map<String, dynamic>
//     if (value == 'edit' && result is Map<String, dynamic>) {
//       // Ambil field yang ada, pakai nilai fallback dari currentData
//       final updated = <String, dynamic>{
//         'pekerjaan': result['pekerjaan'] ?? currentData['pekerjaan'] ?? '',
//         'alamatRumah': result['alamatRumah'] ?? currentData['alamatRumah'] ?? '',
//         'hobi': result['hobi'] ?? currentData['hobi'] ?? '',
//         'status': result['status'] ?? currentData['status'] ?? '',
//         'bio': result['bio'] ?? currentData['bio'] ?? '',
//       };
//       await _applyUpdatedData(updated);
//       // tidak perlu setState manual karena StreamBuilder akan rebuild
//     }
//   }

//   Widget buildInfoTile(
//       String label, String value, Color labelColor, Color valueColor) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: TextStyle(fontSize: 14, color: labelColor)),
//           const SizedBox(height: 4),
//           Text(
//             value.isNotEmpty ? value : "-",
//             style: TextStyle(fontSize: 16, color: valueColor),
//           ),
//           const Divider(),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final settings = Provider.of<SettingsProvider>(context);
//     final isDarkMode = settings.backgroundMode == "Hitam";

//     final backgroundColor = isDarkMode ? Colors.black : Colors.grey[100]!;
//     final textColor = isDarkMode ? Colors.white : Colors.black87;
//     final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.blueGrey;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         title: Text(
//           "Profile Page",
//           style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             icon: Icon(Icons.more_vert,
//                 color: isDarkMode ? Colors.white : Colors.black),
//             onSelected: handleMenuSelection,
//             itemBuilder: (context) => const [
//               PopupMenuItem(value: 'edit', child: Text('Edit Info Tambahan')),
//               PopupMenuItem(value: 'settings', child: Text('Settings')),
//               PopupMenuItem(value: 'about', child: Text('About Us')),
//             ],
//           ),
//         ],
//       ),
//       body: StreamBuilder<Map<String, dynamic>>(
//         stream: _profileProvider.stream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(child: Text("Gagal memuat profil"));
//           }
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           currentData = snapshot.data ?? {};

//           return ListView(
//             key: const ValueKey("profileLoaded"),
//             children: [
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//                 child: Row(
//                   children: [
//                     Stack(
//                       alignment: Alignment.bottomRight,
//                       children: [
//                         SizedBox(
//                           width: 100,
//                           height: 100,
//                           child: CircleAvatar(
//                             radius: 50,
//                             backgroundImage: _profileImageBytes != null
//                                 ? MemoryImage(_profileImageBytes!)
//                                 : const AssetImage('assets/images/1.png')
//                                     as ImageProvider,
//                             backgroundColor: Colors.white,
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 4,
//                           right: 4,
//                           child: GestureDetector(
//                             onTap: _showImagePickerOptions,
//                             child: CircleAvatar(
//                               radius: 14,
//                               backgroundColor: Colors.blueAccent,
//                               child: const Icon(Icons.edit,
//                                   size: 16, color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(name,
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: textColor)),
//                           const SizedBox(height: 4),
//                           Text(email,
//                               style: TextStyle(
//                                   fontSize: 14, color: subTextColor)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(),
//               buildInfoTile("Nomor HP", nohp, subTextColor, textColor),
//               buildInfoTile("Jenis Kelamin", gender, subTextColor, textColor),
//               buildInfoTile("Umur", umur, subTextColor, textColor),
//               buildInfoTile("Tempat/Tanggal Lahir", ttl, subTextColor, textColor),
//               const SizedBox(height: 12),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text("Informasi Tambahan",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: textColor)),
//               ),
//               const SizedBox(height: 8),
//               buildInfoTile("Pekerjaan", currentData["pekerjaan"] ?? "", subTextColor, textColor),
//               buildInfoTile("Alamat Rumah", currentData["alamatRumah"] ?? "", subTextColor, textColor),
//               buildInfoTile("Hobi", currentData["hobi"] ?? "", subTextColor, textColor),
//               buildInfoTile("Status Pernikahan", currentData["status"] ?? "", subTextColor, textColor),
//               buildInfoTile("Bio", currentData["bio"] ?? "", subTextColor, textColor),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
// /Eka/activity/Profile_Page.dart : setelah ada firestore ganteng punya eka
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '/Eka/provider/settings_provider.dart';
import '/Eka/activity/Profile_Edit.dart';
import '/Eka/activity/Profile_Settings.dart';
import '/Eka/activity/Profile_About.dart';
import '/Eka/provider/firestore_service.dart';
import '/Eka/provider/firebase_helper.dart';

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
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked == null) return;

      setState(() => _isUploading = true);
      final file = File(picked.path);

      // Simpan gambar secara lokal
      await _saveLocalImage(file);

      // Konversi ke Base64 untuk disimpan di Firestore
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      await FirestoreService()
          .saveProfileData({'profileImageBase64': base64String}, 'user_001');

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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
              await FirestoreService()
                  .saveProfileData({'profileImageBase64': ''}, 'user_001');
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
    Widget page;
    if (value == 'edit') {
      page = ProfileEdit(
        pekerjaan: currentData['pekerjaan'] ?? '',
        alamatRumah: currentData['alamatRumah'] ?? '',
        hobi: currentData['hobi'] ?? '',
        status: currentData['status'] ?? '',
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

  Widget buildInfoTile(
      String label, String value, Color labelColor, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: labelColor, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value.isNotEmpty ? value : "-",
              style: TextStyle(color: valueColor, fontSize: 16)),
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
              PopupMenuItem(value: 'edit', child: Text('Edit Info Tambahan')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'about', child: Text('About Us')),
            ],
          ),
        ],
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: FirestoreService().getProfileStream('user_001'),
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

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(radius: 50, backgroundImage: imageProvider),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.blueAccent,
                              child: Icon(Icons.edit,
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
                          Text("Ultraman Nex",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor)),
                          Text("ultramannex@gmail.com",
                              style: TextStyle(color: subTextColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              buildInfoTile(
                  "Nomor HP", "+62 821-6679-7788", subTextColor, textColor),
              buildInfoTile("Jenis Kelamin", "Laki-laki", subTextColor, textColor),
              buildInfoTile("Umur", "300 Tahun", subTextColor, textColor),
              buildInfoTile("Tempat/Tanggal Lahir", "Planet Mars, 20 Oktober",
                  subTextColor, textColor),
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
              buildInfoTile("Pekerjaan", currentData["pekerjaan"] ?? "",
                  subTextColor, textColor),
              buildInfoTile("Alamat Rumah", currentData["alamatRumah"] ?? "",
                  subTextColor, textColor),
              buildInfoTile("Hobi", currentData["hobi"] ?? "",
                  subTextColor, textColor),
              buildInfoTile("Status Pernikahan", currentData["status"] ?? "",
                  subTextColor, textColor),
              buildInfoTile(
                  "Bio", currentData["bio"] ?? "", subTextColor, textColor),
            ],
          );
        },
      ),
    );
  }
}
