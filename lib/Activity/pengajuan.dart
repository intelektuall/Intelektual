import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../Provider/hewan_provider.dart';

class AddAnimalScreen extends StatefulWidget {
  @override
  _AddAnimalScreenState createState() => _AddAnimalScreenState();
}

class SubmissionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HewanProvider>(context);
    final submissions = provider.submissions;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Riwayat Pengajuan',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        iconTheme: Theme.of(context).iconTheme,
      ),

      body: submissions.isEmpty
          ? Center(
              child: Text(
                'Belum ada riwayat pengajuan',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final submission = submissions[index];
                return Card(
                  color: Theme.of(context).cardColor,
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      Icons.pets,
                      color: submission['status'] == 'Approved'
                          ? Colors.green
                          : submission['status'] == 'Rejected'
                          ? Colors.red
                          : Colors.orange,
                    ),
                    title: Text(submission['name'] ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(submission['status'] ?? 'No Status'),
                        Text(
                          submission['timestamp'].toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.chevron_right)],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isSubmitting = false;
  bool _showBanner = true;
  late FormController formController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    formController = Provider.of<HewanProvider>(
      context,
      listen: false,
    ).formController;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null && pickedFile.path.isNotEmpty) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        Get.snackbar(
          'Peringatan',
          'Tidak ada gambar yang dipilih',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Mengambil Gambar',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('Error picking image: $e');
    }
  }

  void showLoadingDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Loading',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Mengirim data...", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              runSpacing: 10,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.photo, color: Colors.blueAccent),
                  title: const Text('Pilih dari Galeri'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
                  title: const Text('Ambil dari Kamera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.cancel, color: Colors.red),
                  label: Text("Batal", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto Hewan*',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _imageFile == null
                    ? Theme.of(context).dividerColor
                    : Colors.blueAccent,
                width: 1.5,
              ),
            ),

            child: _imageFile == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Tambahkan Foto',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                : FutureBuilder<File>(
                    future: Future.value(_imageFile),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(snapshot.data!, fit: BoxFit.cover),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Ajukan Hewan Baru',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).cardColor,
                    title: Text('Informasi Pengajuan'),
                    content: Text(
                      'Data yang Anda ajukan akan diverifikasi terlebih dahulu...',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Mengerti'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          if (_showBanner)
            MaterialBanner(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              content: Text(
                "Pastikan hewan yang Anda tambahkan belum terdaftar di aplikasi",
                style: TextStyle(color: Colors.blueAccent[800]),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "TUTUP",
                    style: TextStyle(color: Colors.blueAccent[800]),
                  ),
                  onPressed: () => setState(() => _showBanner = false),
                ),
              ],
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: FormBuilder(
                key: formController.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImagePreview(),
                    SizedBox(height: 24),
                    FormBuilderTextField(
                      name: 'name',
                      controller: formController.nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Hewan*',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        hintStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),

                      validator: FormBuilderValidators.required(
                        errorText: 'Nama hewan harus diisi',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Jenis Hewan*',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color
                      ),
                    ),
                    SizedBox(height: 8),
                    ...['Mamalia', 'Reptil', 'Ikan', 'Burung'].map(
                      (type) => Obx(
                        () => RadioListTile(
                          title: Text(type),
                          value: type,
                          groupValue: formController.selectedType.value,
                          onChanged: (val) =>
                              formController.selectedType.value = val as String,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Lokasi*',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          ['Hindia', 'Atlantik', 'Pasifik', 'Selatan', 'Arktik']
                              .map(
                                (loc) => Obx(
                                  () => ChoiceChip(
                                    label: Text("Samudra $loc"),
                                    selected:
                                        formController.selectedLocation.value ==
                                        loc,
                                    onSelected: (selected) =>
                                        formController.selectedLocation.value =
                                            selected ? loc : '',
                                    selectedColor: Colors.blueAccent[100],
                                    labelStyle: TextStyle(
                                      color:
                                          formController
                                                  .selectedLocation
                                                  .value ==
                                              loc
                                          ? Colors.blueAccent[800]
                                          : Colors.grey[800],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'count',
                      controller: formController.countController,
                      decoration: InputDecoration(
                        labelText: 'Perkiraan jumlah yang masih hidup*',
                        border: OutlineInputBorder(),
                        hintText: 'Contoh: 1500',
                      ),
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: 'Jumlah harus diisi',
                        ),
                        FormBuilderValidators.numeric(
                          errorText: 'Harus berupa angka',
                        ),
                      ]),
                    ),
                    SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'desc',
                      controller: formController.descController,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi hewan*',
                        border: OutlineInputBorder(),
                        hintText: 'Ciri-ciri, habitat, perilaku, dll',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      validator: FormBuilderValidators.required(
                        errorText: 'Deskripsi harus diisi',
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      color: Colors.grey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Perhatian:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[800],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '1. Pastikan data yang Anda masukkan akurat\n'
                              '2. Foto harus asli dan jelas\n'
                              '3. Pengajuan palsu akan ditolak',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => CheckboxListTile(
                        title: Text(
                          'Saya menyatakan data yang diisi adalah benar dan siap untuk diverifikasi',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: formController.isAgreed.value,
                        onChanged: (val) =>
                            formController.isAgreed.value = val ?? false,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () {
                                    formController.resetForm();
                                    setState(() => _imageFile = null);
                                    Navigator.pop(context);
                                    Get.snackbar(
                                      'Dibatalkan',
                                      'Pengajuan dibatalkan',
                                      duration: Duration(seconds: 2),
                                    );
                                  },
                            child: Text('Batal'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Obx(
                            () => OutlinedButton(
                              onPressed:
                                  formController.isAgreed.value &&
                                      !_isSubmitting
                                  ? () async {
                                      if (formController.formKey.currentState
                                              ?.saveAndValidate() ??
                                          false) {
                                        if (formController
                                                .selectedType
                                                .value
                                                .isEmpty ||
                                            formController
                                                .selectedLocation
                                                .value
                                                .isEmpty) {
                                          Get.snackbar(
                                            'Form Tidak Lengkap',
                                            'Harap pilih jenis dan lokasi hewan',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                          return;
                                        }

                                        if (_imageFile == null) {
                                          Get.snackbar(
                                            'Foto Diperlukan',
                                            'Harap tambahkan foto hewan',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                          return;
                                        }

                                        showLoadingDialog(); // 👈 Tambahkan ini
                                        setState(() => _isSubmitting = true);

                                        try {
                                          final formData = {
                                            'name': formController
                                                .nameController
                                                .text,
                                            'type': formController
                                                .selectedType
                                                .value,
                                            'location': formController
                                                .selectedLocation
                                                .value,
                                            'count': formController
                                                .countController
                                                .text,
                                            'desc': formController
                                                .descController
                                                .text,
                                            'image': _imageFile?.path ?? '',
                                            'timestamp': DateTime.now(),
                                            'status': 'Pending',
                                          };

                                          final provider =
                                              Provider.of<HewanProvider>(
                                                context,
                                                listen: false,
                                              );
                                          await Future.delayed(
                                            Duration(seconds: 2),
                                          ); // Simulasi delay kirim
                                          provider.addSubmission(formData);

                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pop(); //
                                          setState(() {
                                            _isSubmitting = false;
                                            _imageFile = null;
                                          });

                                          Get.snackbar(
                                            'Berhasil',
                                            'Pengajuan hewan berhasil dikirim',
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            duration: Duration(seconds: 3),
                                          );

                                          formController.resetForm();
                                          if (mounted) Navigator.pop(context);
                                        } catch (e) {
                                          Navigator.of(
                                            context,
                                            rootNavigator: true,
                                          ).pop(); //
                                          setState(() => _isSubmitting = false);
                                          Get.snackbar(
                                            'Error',
                                            'Gagal mengirim pengajuan: $e',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }
                                      }
                                    }
                                  : null,

                              child: _isSubmitting
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.blueAccent,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Ajukan',
                                      style: TextStyle(
                                        color:
                                            formController.isAgreed.value &&
                                                !_isSubmitting
                                            ? Colors.blueAccent
                                            : Colors.grey,
                                      ),
                                    ),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(
                                  color:
                                      formController.isAgreed.value &&
                                          !_isSubmitting
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
