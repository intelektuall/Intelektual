import 'package:flutter/material.dart';
import 'event_model.dart';
import 'db_helper.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  List<Event> get events => _events;

  EventProvider() {
    loadEvents();
  }

  /// Load semua event dari DB dan kembalikan List<Event>
  Future<List<Event>> loadEvents() async {
    // Pastikan DBHelper.getEvents() mengembalikan List<Event>
    _events = await DBHelper.getEvents();
    notifyListeners();
    return _events;
  }

  /// Tambah event ke DB
  Future<void> addEvent(Event event) async {
    await DBHelper.insertEvent(event);
    await loadEvents();
  }

  /// Toggle joined (update di DB)
  Future<void> toggleJoin(Event event) async {
    final updated = Event(
      id: event.id,
      title: event.title,
      category: event.category,
      location: event.location,
      date: event.date,
      startTime: event.startTime,
      endTime: event.endTime,
      joined: !event.joined,
    );
    await DBHelper.updateEvent(updated);
    await loadEvents();
  }

  /// Hapus event berdasarkan id
  Future<void> deleteEvent(int id) async {
    await DBHelper.deleteEvent(id);
    await loadEvents();
  }

  /// Hapus semua event (reset)
  Future<void> clearEvents() async {
    await DBHelper.clearEvents();
    await loadEvents();
  }
}
