import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/Eka/provider/firestore_service_base.dart';
import '/Eka/provider/firebase_helper.dart';

class ProfileEdit extends StatefulWidget {
  final FirestoreServiceBase firestore;
  final String pekerjaan, alamatRumah, hobi, status, bio;

  const ProfileEdit({
    super.key,
    required this.firestore,
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
    hobiController = TextEditingController(text: widget.hobi);
    statusController = TextEditingController(text: widget.status);
    bioController = TextEditingController(text: widget.bio);

    FirebaseAnalyticsHelper.setCurrentScreen(screenName: 'ProfileEdit');

    _loadExistingData();
  }

  // ================= LOAD DATA (MOCK / REAL) =================
  Future<void> _loadExistingData() async {
    final data = await widget.firestore.getProfileOnce();
    if (data.isEmpty) return;

    setState(() {
      namaController.text = data['nama'] ?? '';
      emailController.text = data['email'] ?? '';
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

      final ttl = data['tempatTanggalLahir'] ?? '';
      if (ttl.contains(',')) {
        final parts = ttl.split(',');
        tempatLahirController.text = parts[0].trim();
        try {
          selectedTanggalLahir = DateFormat(
            'dd/MM/yyyy',
          ).parseStrict(parts[1].trim());
          _updateUmur();
        } catch (_) {}
      }
    });
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

    umurController.text = age.toString();
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

  Future<void> saveData() async {
    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap setujui perubahan terlebih dahulu"),
        ),
      );
      return;
    }

    List<String> hobiList = [];
    if (hobiController.text.trim().isNotEmpty) {
      hobiList = hobiController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    String tempatTanggalLahir = tempatLahirController.text.trim();
    if (selectedTanggalLahir != null) {
      tempatTanggalLahir +=
          ", ${DateFormat('dd/MM/yyyy').format(selectedTanggalLahir!)}";
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

    await widget.firestore.saveProfileData(updatedData);

    if (mounted) {
      Navigator.pop(context, updatedData);
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

  Widget buildEditableField(
    String label,
    TextEditingController controller,
    Key fieldKey, {
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
            key: fieldKey,
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
                  key: const Key('field_tempat_lahir'),
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
                  key: const Key('field_tanggal_lahir'),
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
      body: SingleChildScrollView(
        key: const Key('profile_edit_scroll'),
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        child: Column(
          children: [
            buildEditableField("Nama", namaController, const Key('field_nama')),
            buildEditableField(
              "Email",
              emailController,
              const Key('field_email'),
              readOnly: true,
            ),
            buildEditableField(
              "Nomor HP",
              nomorHPController,
              const Key('field_nomor_hp'),
            ),
            buildEditableField(
              "Jenis Kelamin",
              jenisKelaminController,
              const Key('field_jenis_kelamin'),
            ),
            buildEditableField(
              "Umur",
              umurController,
              const Key('field_umur'),
              readOnly: true,
            ),
            buildTempatTanggalField(),
            buildEditableField(
              "Pekerjaan",
              pekerjaanController,
              const Key('field_pekerjaan'),
            ),
            buildEditableField(
              "Alamat Rumah",
              alamatController,
              const Key('field_alamat'),
            ),
            buildEditableField(
              "Hobi",
              hobiController,
              const Key('field_hobi'),
              hintText:
                  "Pisahkan dengan koma (contoh: Membaca, Menulis, Traveling)",
            ),
            buildEditableField(
              "Status Pernikahan",
              statusController,
              const Key('field_status'),
            ),
            buildEditableField(
              "Bio",
              bioController,
              const Key('field_bio'),
              maxLines: 3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CheckboxListTile(
                key: const Key('checkbox_agree'),
                title: const Text("Saya menyetujui untuk menyimpan perubahan"),
                value: agree,
                onChanged: (val) => setState(() => agree = val ?? false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                key: const Key('btn_save_profile'),
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
      ),
    );
  }
}
