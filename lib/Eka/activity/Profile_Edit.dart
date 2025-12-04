import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/Eka/provider/firestore_service.dart';
import '/Eka/provider/firebase_helper.dart';
import 'package:intl/intl.dart';

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
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController nomorHPController;
  late TextEditingController jenisKelaminController;
  late TextEditingController umurController;
  late TextEditingController tempatLahirController;
  DateTime? selectedTanggalLahir;

  late TextEditingController pekerjaanController;
  late TextEditingController alamatController;
  late TextEditingController hobiController;
  late TextEditingController statusController;
  late TextEditingController bioController;
  bool agree = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController();
    emailController = TextEditingController();
    nomorHPController = TextEditingController();
    jenisKelaminController = TextEditingController();
    umurController = TextEditingController();
    tempatLahirController = TextEditingController();

    pekerjaanController = TextEditingController(text: widget.pekerjaan);
    alamatController = TextEditingController(text: widget.alamatRumah);

    // Hobi bisa list atau string
    final hobiString = widget.hobi is List
        ? (widget.hobi as List).join(", ")
        : widget.hobi;
    hobiController = TextEditingController(text: hobiString);

    statusController = TextEditingController(text: widget.status);
    bioController = TextEditingController(text: widget.bio);

    FirebaseAnalyticsHelper.setCurrentScreen(screenName: 'ProfileEdit');

    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final data = await FirestoreService().getProfileOnce(user.uid);
    if (data.isNotEmpty) {
      setState(() {
        namaController.text = data['nama'] ?? user.displayName ?? '';
        emailController.text = data['email'] ?? user.email ?? '';
        nomorHPController.text = data['nomorHP'] ?? '';
        jenisKelaminController.text = data['jenisKelamin'] ?? '';
        pekerjaanController.text = data['pekerjaan'] ?? '';
        alamatController.text = data['alamatRumah'] ?? '';

        if (data['hobi'] is List) {
          hobiController.text = (data['hobi'] as List).join(', ');
        } else {
          hobiController.text = data['hobi'] ?? '';
        }

        statusController.text = data['statusPernikahan'] ?? '';
        bioController.text = data['bio'] ?? '';

        // 🔹 Pisahkan tempat dan tanggal lahir kalau ada datanya
        final ttl = data['tempatTanggalLahir'] ?? '';
        if (ttl.contains(',')) {
          final parts = ttl.split(',');
          tempatLahirController.text = parts[0].trim();
          final datePart = parts.length > 1 ? parts[1].trim() : '';
          try {
            selectedTanggalLahir = DateFormat(
              "dd/MM/yyyy",
            ).parseStrict(datePart);
            _updateUmur();
          } catch (_) {}
        }
      });
    }
  }

  void _updateUmur() {
    if (selectedTanggalLahir == null) return;
    final today = DateTime.now();
    int age = today.year - selectedTanggalLahir!.year;
    if (today.month < selectedTanggalLahir!.month ||
        (today.month == selectedTanggalLahir!.month &&
            today.day < selectedTanggalLahir!.day)) {
      age--;
    }
    setState(() {
      umurController.text = age.toString();
    });
  }

  Future<void> _selectTanggalLahir(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggalLahir ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      setState(() {
        selectedTanggalLahir = picked;
        _updateUmur();
      });
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    nomorHPController.dispose();
    jenisKelaminController.dispose();
    umurController.dispose();
    tempatLahirController.dispose();
    pekerjaanController.dispose();
    alamatController.dispose();
    hobiController.dispose();
    statusController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> saveData() async {
    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap setujui perubahan terlebih dahulu"),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User belum login")));
      return;
    }

    // Konversi hobi ke list
    List<String> hobiList = [];
    if (hobiController.text.trim().isNotEmpty) {
      hobiList = hobiController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    // Format Tempat/Tanggal Lahir
    String tempatTanggalLahir = tempatLahirController.text.trim();
    if (selectedTanggalLahir != null) {
      final formattedDate = DateFormat(
        'dd/MM/yyyy',
      ).format(selectedTanggalLahir!);
      tempatTanggalLahir = "$tempatTanggalLahir, $formattedDate";
    }

    final updatedData = {
      'nama': namaController.text.trim(),
      'email': emailController.text.trim(),
      'nomorHP': nomorHPController.text.trim(),
      'jenisKelamin': jenisKelaminController.text.trim(),
      'umur': umurController.text.trim(),
      'tempatTanggalLahir': tempatTanggalLahir,
      'pekerjaan': pekerjaanController.text.trim(),
      'alamatRumah': alamatController.text.trim(),
      'hobi': hobiList,
      'statusPernikahan': statusController.text.trim(),
      'bio': bioController.text.trim(),
    };

    try {
      await FirestoreService().saveProfileData(updatedData, user.uid);
      FirebaseAnalyticsHelper.logEvent(
        name: 'profile_edit_saved',
        parameters: {'fields': updatedData.keys.join(',')},
      );

      if (mounted) {
        Navigator.pop(context, updatedData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Perubahan berhasil disimpan")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan: $e")));
    }
  }

  Widget buildEditableField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    bool readOnly = false,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: readOnly,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTempatTanggalField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tempat & Tanggal Lahir",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: tempatLahirController,
                  decoration: InputDecoration(
                    hintText: "Tempat lahir",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () => _selectTanggalLahir(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                    ),
                    child: Text(
                      selectedTanggalLahir != null
                          ? DateFormat(
                              'dd/MM/yyyy',
                            ).format(selectedTanggalLahir!)
                          : "Pilih Tanggal",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
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
        title: const Text("Edit Profil", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        children: [
          buildEditableField("Nama", namaController),
          buildEditableField("Email", emailController, readOnly: true),
          buildEditableField("Nomor HP", nomorHPController),
          buildEditableField("Jenis Kelamin", jenisKelaminController),
          buildEditableField("Umur", umurController, readOnly: true),
          buildTempatTanggalField(),
          buildEditableField("Pekerjaan", pekerjaanController),
          buildEditableField("Alamat Rumah", alamatController),
          buildEditableField(
            "Hobi",
            hobiController,
            hintText:
                "Pisahkan dengan koma (contoh: Membaca, Menulis, Traveling)",
          ),
          buildEditableField("Status Pernikahan", statusController),
          buildEditableField("Bio", bioController, maxLines: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CheckboxListTile(
              title: const Text("Saya menyetujui untuk menyimpan perubahan"),
              value: agree,
              onChanged: (val) => setState(() => agree = val ?? false),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: agree ? saveData : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Simpan Perubahan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
