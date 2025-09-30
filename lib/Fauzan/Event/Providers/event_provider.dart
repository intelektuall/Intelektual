import 'package:flutter/material.dart';

// Model
class Event {
  final String title;
  final String category;
  final String location;
  final DateTime? date;
  final String? startTime; // waktu mulai
  final String? endTime; // waktu selesai
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

// Provider
class EventProvider with ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => _events;

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void toggleJoin(Event event) {
    event.joined = !event.joined;
    notifyListeners();
  }
}
