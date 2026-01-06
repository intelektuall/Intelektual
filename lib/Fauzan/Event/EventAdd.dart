import 'package:flutter/material.dart';
import 'package:sopan_santun_app/Fauzan/Event/EventDataList/event_constants.dart';
import 'package:sopan_santun_app/Fauzan/Event/Widget/custom_dropdown.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class TambahEventPage extends StatefulWidget {
  @override
  _TambahEventPageState createState() => _TambahEventPageState();
}

class _TambahEventPageState extends State<TambahEventPage> {
  final _formKey = GlobalKey<FormState>();
  String? namaEvent;
  String? lokasi;
  String? kota;
  String? kotaError;
  String? kategori;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? lokasiError;
  String? kategoriError;

  @override
  void initState() {
    super.initState();
    _detectProvinceFromGPS();
  }

  Future<void> _detectProvinceFromGPS() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return;

      final rawProvince = placemarks.first.administrativeArea ?? '';
      final normalized = normalizeProvince(rawProvince);

      if (provinces.contains(normalized)) {
        setState(() {
          lokasi = normalized; // 🔥 AUTO SELECT DROPDOWN
        });
      }
    } catch (e) {
      debugPrint('GPS error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Event"),
        backgroundColor: Colors.blueAccent.withOpacity(0.7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama Event", style: labelStyle),
              SizedBox(height: 8),
              TextFormField(
                decoration: inputDecoration("Masukkan nama event"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
                onChanged: (val) => namaEvent = val,
              ),
              SizedBox(height: 20),

              Text("Lokasi", style: labelStyle),
              SizedBox(height: 8),

              CustomDropdown(
                hint: "Pilih Provinsi",
                value: lokasi,
                items: provinces.where((p) => p != 'None').toList(),
                onChanged: (val) {
                  setState(() {
                    lokasi = val;
                    lokasiError = null;
                  });
                },
              ),

              if (lokasiError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 8),
                  child: Text(
                    lokasiError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              SizedBox(height: 12),

              // ================= KOTA =================
              CustomDropdown(
                hint: lokasi == null ? "Pilih Provinsi dahulu" : "Pilih Kota",
                value: kota,
                items: lokasi == null ? [] : citiesByProvince[lokasi] ?? [],
                onChanged: (val) {
                  setState(() {
                    kota = val;
                    kotaError = null;
                  });
                },
              ),

              if (kotaError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 8),
                  child: Text(
                    kotaError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              SizedBox(height: 20),
              Text("Kategori", style: labelStyle),
              SizedBox(height: 8),

              CustomDropdown(
                hint: "Pilih Kategori",
                value: kategori,
                items: eventCategories.where((c) => c != 'None').toList(),
                onChanged: (val) {
                  setState(() {
                    kategori = val;
                    kategoriError = null;
                  });
                },
              ),

              if (kategoriError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 8),
                  child: Text(
                    kategoriError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              SizedBox(height: 20),

              // ======================= TANGGAL ==========================
              Text("Tanggal", style: labelStyle),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => selectedDate = pickedDate);
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: inputDecoration(
                      selectedDate == null
                          ? "Pilih tanggal"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    ).copyWith(prefixIcon: Icon(Icons.calendar_today_rounded)),
                    validator: (_) =>
                        selectedDate == null ? "Wajib pilih tanggal" : null,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // ===================== WAKTU (Start & End) ======================
              Text("Waktu", style: labelStyle),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return Localizations.override(
                              context: context,
                              locale: const Locale('id'),
                              child: MediaQuery(
                                data: MediaQuery.of(
                                  context,
                                ).copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              ),
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => startTime = picked);
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration:
                              inputDecoration(
                                startTime == null
                                    ? "Waktu mulai"
                                    : startTime!.format(context),
                              ).copyWith(
                                prefixIcon: Icon(Icons.access_time_rounded),
                              ),
                          validator: (_) => startTime == null
                              ? "Wajib pilih waktu mulai"
                              : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return Localizations.override(
                              context: context,
                              locale: const Locale('id'),
                              child: MediaQuery(
                                data: MediaQuery.of(
                                  context,
                                ).copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              ),
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => endTime = picked);
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration:
                              inputDecoration(
                                endTime == null
                                    ? "Waktu selesai"
                                    : endTime!.format(context),
                              ).copyWith(
                                prefixIcon: Icon(Icons.access_time_outlined),
                              ),
                          validator: (_) => endTime == null
                              ? "Wajib pilih waktu selesai"
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final isFormValid = _formKey.currentState!.validate();

                    setState(() {
                      lokasiError = lokasi == null
                          ? "Wajib pilih provinsi"
                          : null;
                      kotaError = kota == null ? "Wajib pilih kota" : null;
                      kategoriError = kategori == null
                          ? "Wajib pilih kategori"
                          : null;
                    });

                    if (isFormValid &&
                        lokasi != null &&
                        kota != null &&
                        kategori != null) {
                      Navigator.pop(context, {
                        'status': true,
                        'nama': namaEvent!,
                        'kategori': kategori!,
                        'lokasi': lokasi!,
                        'kota': kota!,
                        'tanggal': selectedDate,
                        'startTime': startTime!.format(context),
                        'endTime': endTime!.format(context),
                      });
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Simpan",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey[800],
  );

  InputDecoration inputDecoration(String? hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    isDense: true,
  );
}
