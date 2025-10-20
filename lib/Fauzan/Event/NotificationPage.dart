import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'Notification/notification_provider.dart';
import 'Notification/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).loadNotifications();
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>().notifications;

    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Notifikasi"),
        backgroundColor: Colors.blueAccent.withOpacity(0.7),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // ⏳ Loading indikator
          : notifications.isEmpty
          ? Center(child: Text("Belum ada notifikasi."))
          : ListView.separated(
              itemCount: notifications.length,
              padding: EdgeInsets.all(16),
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = notifications[index];
                final formattedTime = DateFormat(
                  'dd/MM/yyyy - HH:mm',
                ).format(item.timestamp);

                // Tentukan teks berdasarkan tipe notifikasi
                final isJoin = item.tipe == 'join';
                final titleText = isJoin
                    ? "Anda Bergabung ke Event ${item.nama}"
                    : "Persetujuan Event ${item.nama}";
                final contentText = isJoin
                    ? 'Anda telah bergabung dengan event berikut.\n\nNama Event: ${item.nama}\nLokasi: ${item.lokasi}\n\n$formattedTime'
                    : 'Event anda dengan detail ini sudah disetujui oleh tim kami.\n\nNama Event: ${item.nama}\nLokasi: ${item.lokasi}\n\n$formattedTime';

                return ExpansionTileCard(
                  baseColor: isJoin ? Colors.green[50] : Colors.blue[50],
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  leading: Icon(
                    isJoin
                        ? Icons.event_available_outlined
                        : Icons.notifications_none_outlined,
                  ),
                  title: Text(titleText),
                  subtitle: Text(formattedTime),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: Text(contentText, style: TextStyle(fontSize: 14)),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 12),
                        child: ElevatedButton(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return DraggableScrollableSheet(
                                expand: false,
                                initialChildSize: 0.4,
                                minChildSize: 0.2,
                                maxChildSize: 0.8,
                                builder: (context, scrollController) {
                                  return SingleChildScrollView(
                                    controller: scrollController,
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 40,
                                            height: 4,
                                            margin: EdgeInsets.only(bottom: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          isJoin
                                              ? "Detail Event yang Anda Ikuti"
                                              : "Detail Notifikasi",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          "Judul Event:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(item.nama),
                                        SizedBox(height: 16),
                                        Text(
                                          "Lokasi:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(item.lokasi),
                                        SizedBox(height: 16),
                                        Text(
                                          "Waktu:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(formattedTime),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isJoin
                                ? Colors.green
                                : Colors.blueAccent,
                          ),
                          child: Text("Lihat Detail"),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
