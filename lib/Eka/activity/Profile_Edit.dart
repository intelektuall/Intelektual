// /Eka/activity/Profile_Edit.dart
import 'package:flutter/material.dart';
import '/Eka/provider/profile_stream.dart';
import '/Eka/provider/firebase_helper.dart'; // <-- import helper

class ProfileEdit extends StatefulWidget {
  final String pekerjaan, alamatRumah, hobi, status, bio;

  const ProfileEdit({
    super.key,
    required this.pekerjaan,
    required this.alamatRumah,
    required this.hobi,
    required this.status,
    required this.bio,
  });

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late TextEditingController pekerjaanController;
  late TextEditingController alamatController;
  late TextEditingController hobiController;
  late TextEditingController statusController;
  late TextEditingController bioController;

  bool agree = false;

  @override
  void initState() {
    super.initState();
    pekerjaanController = TextEditingController(text: widget.pekerjaan);
    alamatController = TextEditingController(text: widget.alamatRumah);
    hobiController = TextEditingController(text: widget.hobi);
    statusController = TextEditingController(text: widget.status);
    bioController = TextEditingController(text: widget.bio);

    // Log screen view saat halaman Edit dibuka
    FirebaseAnalyticsHelper.setCurrentScreen(screenName: 'ProfileEdit');
  }

  @override
  void dispose() {
    pekerjaanController.dispose();
    alamatController.dispose();
    hobiController.dispose();
    statusController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void saveData() async {
    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap setujui perubahan terlebih dahulu")),
      );

      // Log event user coba simpan tanpa setuju
      FirebaseAnalyticsHelper.logEvent(name: 'edit_save_blocked_no_agree');

      return;
    }

    final updatedData = {
      'pekerjaan': pekerjaanController.text,
      'alamatRumah': alamatController.text,
      'hobi': hobiController.text,
      'status': statusController.text,
      'bio': bioController.text,
    };

    // Update ke provider (akan menyimpan ke SharedPreferences juga)
    await ProfileStreamProvider().updateProfile(updatedData);

    // Log event ketika user menyimpan perubahan
    FirebaseAnalyticsHelper.logEvent(
      name: 'profile_edit_saved',
      parameters: {
        'pekerjaan_len': pekerjaanController.text.length,
        'alamat_len': alamatController.text.length,
      },
    );

    // kembali dengan result
    if (mounted) Navigator.pop(context, updatedData);
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: label == "Bio" ? 3 : 1,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Edit Info Tambahan", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        children: [
          buildEditableField("Pekerjaan", pekerjaanController),
          buildEditableField("Alamat Rumah", alamatController),
          buildEditableField("Hobi", hobiController),
          buildEditableField("Status Pernikahan", statusController),
          buildEditableField("Bio", bioController),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CheckboxListTile(
              title: const Text("Saya menyetujui untuk menyimpan perubahan"),
              value: agree,
              onChanged: (val) {
                setState(() => agree = val ?? false);

                // Log event saat user toggle checkbox persetujuan
                FirebaseAnalyticsHelper.logEvent(
                  name: 'edit_agree_toggled',
                  parameters: {'agree': agree},
                );
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: agree ? saveData : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
