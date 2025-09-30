import 'package:flutter/material.dart';

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
  }

  void saveData() {
    if (agree) {
      Navigator.pop(context, {
        'pekerjaan': pekerjaanController.text,
        'alamatRumah': alamatController.text,
        'hobi': hobiController.text,
        'status': statusController.text,
        'bio': bioController.text,
      });
    }
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Tooltip(
            message: "Edit $label",
            child: TextField(
              controller: controller,
              maxLines: label == "Bio" ? 3 : 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Edit Info Tambahan",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 4,
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
            child: Tooltip(
              message: "Wajib menyetujui untuk menyimpan perubahan",
              child: CheckboxListTile(
                title: const Text("Saya menyetujui untuk menyimpan perubahan"),
                value: agree,
                onChanged: (val) => setState(() => agree = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Tooltip(
              message: "Klik untuk menyimpan perubahan",
              child: ElevatedButton(
                onPressed: agree ? saveData : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: agree ? Colors.blueAccent : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
