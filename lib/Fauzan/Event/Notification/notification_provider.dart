import 'package:flutter/material.dart';
import 'notification_model.dart';
import 'notification_database.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  /// Muat data dari database saat aplikasi dibuka
  Future<void> loadNotifications() async {
    final data = await NotificationDatabase.instance.getAllNotifications();
    _notifications.clear();
    _notifications.addAll(data);
    notifyListeners();
  }

  /// Notifikasi event disetujui
  Future<void> addNotification(String nama, String lokasi) async {
    final notif = NotificationModel(
      nama: nama,
      lokasi: lokasi,
      timestamp: DateTime.now(),
      tipe: 'approval',
    );

    _notifications.insert(0, notif);
    notifyListeners();

    await NotificationDatabase.instance.insertNotification(notif);
  }

  /// 🔔 Notifikasi ketika user bergabung ke event
  Future<void> addJoinNotification(String nama, String lokasi) async {
    final notif = NotificationModel(
      nama: nama,
      lokasi: lokasi,
      timestamp: DateTime.now(),
      tipe: 'join',
    );

    _notifications.insert(0, notif);
    notifyListeners();

    await NotificationDatabase.instance.insertNotification(notif);
  }

  /// Hapus semua notifikasi
  Future<void> clearAll() async {
    await NotificationDatabase.instance.deleteAll();
    _notifications.clear();
    notifyListeners();
  }
}
