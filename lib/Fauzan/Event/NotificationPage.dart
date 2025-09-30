import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'Notification/notification_provider.dart';
import 'Notification/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>().notifications;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Notifikasi"),
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.blueAccent,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: notifications.isEmpty
          ? Center(child: Text("Belum ada notifikasi."))
          : ListView.separated(
              itemCount: notifications.length,
              padding: EdgeInsets.all(16),
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = notifications[index];
                final formattedTime =
                    DateFormat('dd/MM/yyyy - HH:mm').format(item.timestamp);

                return ExpansionTileCard(
                  baseColor: theme.cardColor,
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  leading: Icon(Icons.notifications_none_outlined,
                      color: colorScheme.onSurface),
                  title: Text(
                    "Persetujuan Event ${item.nama}",
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    formattedTime,
                    style: theme.textTheme.bodySmall,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: Text(
                        'Event anda dengan detail ini sudah disetujui oleh tim kami .\n\nNama Event: ${item.nama}\nLokasi: ${item.lokasi}\n\n$formattedTime',
                        style: theme.textTheme.bodyMedium,
                      ),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 40,
                                            height: 4,
                                            margin: EdgeInsets.only(bottom: 16),
                                            decoration: BoxDecoration(
                                              color: colorScheme.outlineVariant,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Detail Notifikasi",
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          "Judul Event:",
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(item.nama),
                                        SizedBox(height: 16),
                                        Text(
                                          "Lokasi:",
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(item.lokasi),
                                        SizedBox(height: 16),
                                        Text(
                                          "Waktu Disetujui:",
                                          style: theme.textTheme.bodyMedium?.copyWith(
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
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
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
