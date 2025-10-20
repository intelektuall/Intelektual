class NotificationModel {
  final String nama;
  final String lokasi;
  final DateTime timestamp;
  final String tipe;

  NotificationModel({
    required this.nama,
    required this.lokasi,
    required this.timestamp,
    required this.tipe,
  });

  Map<String, dynamic> toMap() => {
    'nama': nama,
    'lokasi': lokasi,
    'timestamp': timestamp.toIso8601String(),
    'tipe': tipe,
  };

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      nama: map['nama'],
      lokasi: map['lokasi'],
      timestamp: DateTime.parse(map['timestamp']),
      tipe: map['tipe'],
    );
  }
}
