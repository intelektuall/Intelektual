import 'package:flutter/material.dart';
import '../DB/db_helper.dart';

class Event {
  final String title;
  final String category;
  final String location;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  bool joined;

  Event({
    required this.title,
    required this.category,
    required this.location,
    this.date,
    this.startTime,
    this.endTime,
    this.joined = false,
  });
}

class EventProvider with ChangeNotifier {
  final List<Event> _events = [];
  final DBHelper _dbHelper = DBHelper();

  List<Event> get events => _events;

  EventProvider() {
    loadEvents();
  }

  Future<void> loadEvents() async {
    // ✅ Dummy event tetap ada
    _events.clear();
    _events.addAll([
      Event(
        title: "Bersih Pantai",
        location: "Bali",
        category: "Lingkungan",
        date: DateTime(2025, 7, 15),
        startTime: "08:00",
        endTime: "10:00",
      ),
      Event(
        title: "Seminar Kelautan",
        location: "Jakarta",
        category: "Edukasi",
        date: DateTime(2025, 7, 20),
        startTime: "13:30",
        endTime: "15:00",
      ),
      Event(
        title: "Cleaning Sungai Sembahe",
        location: "Medan",
        category: "Sosial",
        date: DateTime(2025, 7, 20),
        startTime: "13:30",
        endTime: "15:00",
      ),
    ]);

    // ✅ Ambil status join dari SQLite
    final statuses = await _dbHelper.getJoinStatuses();
    for (var e in _events) {
      if (statuses.containsKey(e.title)) {
        e.joined = statuses[e.title]!;
      }
    }

    notifyListeners();
  }

  void addEvent(Event event) {
    // Hanya disimpan di memori (tidak ke database)
    _events.add(event);
    notifyListeners();
  }

  Future<void> toggleJoin(Event event) async {
    event.joined = !event.joined;
    await _dbHelper.saveJoinStatus(event.title, event.joined);
    notifyListeners();
  }
}
