import 'package:flutter/material.dart';

class TambahEventPage extends StatefulWidget {
  const TambahEventPage({super.key});

  @override
  _TambahEventPageState createState() => _TambahEventPageState();
}

class _TambahEventPageState extends State<TambahEventPage> {
  final _formKey = GlobalKey<FormState>();
  String? namaEvent;
  String? lokasi;
  String? kategori;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final List<String> lokasiList = [
    'Aceh',
    'Medan',
    'Jakarta',
    'Surabaya',
    'Bali',
  ];
  final List<String> kategoriList = ['Lingkungan', 'Edukasi', 'Sosial'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Event"),
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.blueAccent,
        elevation: 0,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Nama Event", style: theme.textTheme.bodyMedium),
              SizedBox(height: 8),
              TextFormField(
                decoration: inputDecoration(context, "Masukkan nama event"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
                onChanged: (val) => namaEvent = val,
              ),
              SizedBox(height: 20),

              Text("Lokasi", style: theme.textTheme.bodyMedium),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: lokasi,
                hint: Text("Pilih Lokasi"),
                decoration: inputDecoration(context, null),
                items: lokasiList
                    .map(
                      (lok) => DropdownMenuItem(value: lok, child: Text(lok)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => lokasi = val),
                validator: (val) => val == null ? "Wajib pilih lokasi" : null,
              ),
              SizedBox(height: 20),

              Text("Kategori", style: theme.textTheme.bodyMedium),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: kategori,
                hint: Text("Pilih Kategori"),
                decoration: inputDecoration(context, null),
                items: kategoriList
                    .map(
                      (kat) => DropdownMenuItem(value: kat, child: Text(kat)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => kategori = val),
                validator: (val) => val == null ? "Wajib pilih kategori" : null,
              ),
              SizedBox(height: 20),

              Text("Tanggal", style: theme.textTheme.bodyMedium),
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
                      context,
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

              Text("Waktu", style: theme.textTheme.bodyMedium),
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
                                context,
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
                                context,
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
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, {
                        'status': true,
                        'nama': namaEvent!,
                        'kategori': kategori!,
                        'lokasi': lokasi!,
                        'tanggal': selectedDate,
                        'startTime': startTime!.format(context),
                        'endTime': endTime!.format(context),
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Simpan", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(BuildContext context, String? hint) {
    final theme = Theme.of(context);
    return InputDecoration(
      hintText: hint,
      hintStyle: theme.textTheme.bodySmall,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      isDense: true,
    );
  }
}
