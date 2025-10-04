class Event {
  int? id;
  String title;
  String category;
  String location;
  DateTime? date;
  String? startTime;
  String? endTime;
  bool joined;

  Event({
    this.id,
    required this.title,
    required this.category,
    required this.location,
    this.date,
    this.startTime,
    this.endTime,
    this.joined = false,
  });

  // Konversi ke Map untuk SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'location': location,
      'date': date?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'joined': joined ? 1 : 0,
    };
  }

  // Buat Event dari Map DB
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      location: map['location'],
      date: map['date'] != null ? DateTime.tryParse(map['date']) : null,
      startTime: map['startTime'],
      endTime: map['endTime'],
      joined: map['joined'] == 1,
    );
  }
}
