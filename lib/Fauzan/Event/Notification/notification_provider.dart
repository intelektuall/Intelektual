import 'notification_model.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  void addNotification(String nama, String lokasi) {
    _notifications.insert(
      0,
      NotificationModel(nama: nama, lokasi: lokasi, timestamp: DateTime.now()),
    );
    notifyListeners();
  }
}
