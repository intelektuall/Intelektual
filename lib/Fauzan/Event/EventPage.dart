import '/Fauzan/Event/EventAdd.dart';
import '/Fauzan/Event/Widget/custom_dropdown.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/event_provider.dart';
import 'Notification/notification_provider.dart';
import 'NotificationPage.dart';

class EventLautPage extends StatefulWidget {
  @override
  State<EventLautPage> createState() => _EventLautPageState();
}

class _EventLautPageState extends State<EventLautPage> {
  String? selectedLocation;
  String? selectedCategory;
  bool showJoinedOnly = false;
  bool hasUnreadNotification = false;
  String? chatNotification;
  Event? pendingEvent;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<EventProvider>();
      if (provider.events.isEmpty) {
        provider.addEvent(
          Event(
            title: "Bersih Pantai",
            location: "Bali",
            category: "Lingkungan",
            date: DateTime(2025, 7, 15),
            startTime: "08:00",
            endTime: "10:00",
          ),
        );
        provider.addEvent(
          Event(
            title: "Seminar Kelautan",
            location: "Jakarta",
            category: "Edukasi",
            date: DateTime(2025, 7, 20),
            startTime: "13:30",
            endTime: "15:00",
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final events = context.watch<EventProvider>().events;

    final filteredEvents = events.where((event) {
      if (selectedLocation != null && event.location != selectedLocation)
        return false;
      if (selectedCategory != null && event.category != selectedCategory)
        return false;
      if (showJoinedOnly && !event.joined) return false;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events'),
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.blueAccent,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.chat_bubble_outline),
                tooltip: 'Inbox Chat',
                onPressed: () {
                  setState(() {
                    hasUnreadNotification = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationPage()),
                  );
                },
              ),
              if (hasUnreadNotification)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red, // Tetap merah agar terlihat di dark/light
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    value: selectedLocation,
                    hint: "Pilih Lokasi",
                    items: [
                      'None',
                      'Aceh',
                      'Medan',
                      'Jakarta',
                      'Surabaya',
                      'Bali',
                    ],
                    onChanged: (val) {
                      setState(() {
                        selectedLocation = val == 'None' ? null : val;
                      });
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown(
                    hint: "Pilih Kategori",
                    value: selectedCategory,
                    items: ['None', 'Lingkungan', 'Edukasi', 'Sosial'],
                    onChanged: (val) {
                      setState(() {
                        selectedCategory = val == 'None' ? null : val;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Switch(
                  value: showJoinedOnly,
                  onChanged: (val) => setState(() => showJoinedOnly = val),
                  activeColor: colorScheme.primary,
                ),
                Text("Tampilkan yang diikuti"),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: filteredEvents.isEmpty
                  ? Center(child: Text("Tidak ada event ditemukan"))
                  : ListView.separated(
                      itemCount: filteredEvents.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final event = filteredEvents[index];
                        return ExpansionTileCard(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12),
                          baseColor: theme.cardColor,
                          title: Text(
                            event.title,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${event.location} · ${event.category}",
                            style: theme.textTheme.bodySmall,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (event.date != null)
                                    Text(
                                      "Tanggal: ${event.date!.day}/${event.date!.month}/${event.date!.year}",
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  if (event.startTime != null &&
                                      event.endTime != null)
                                    Text(
                                      "Waktu: ${event.startTime} - ${event.endTime}",
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  SizedBox(height: 12),
                                  Text(
                                    event.joined
                                        ? "Kamu telah bergabung di event ini."
                                        : "Ingin bergabung dalam event ini?",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () =>
                                          context.read<EventProvider>().toggleJoin(event),
                                      child: Text(event.joined ? "Batalkan" : "Gabung"),
                                      style: TextButton.styleFrom(
                                        foregroundColor: event.joined
                                            ? colorScheme.error
                                            : colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahEventPage()),
          );

          if (result != null && result['status'] == true) {
            final nama = result['nama'];
            final kategori = result['kategori'];
            final lokasi = result['lokasi'];
            final tanggal = result['tanggal'] as DateTime?;
            final startTime = result['startTime'] as String?;
            final endTime = result['endTime'] as String?;

            pendingEvent = Event(
              title: nama,
              category: kategori,
              location: lokasi,
              date: tanggal,
              startTime: startTime,
              endTime: endTime,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Event "$nama" dengan kategori "$kategori" di "$lokasi" akan direview oleh tim kami.',
                ),
                duration: Duration(seconds: 3),
              ),
            );

            Future.delayed(Duration(seconds: 5), () {
              final notifText = 'Event "$nama" telah disetujui!';

              context.read<NotificationProvider>().addNotification(nama, lokasi);
              context.read<EventProvider>().addEvent(pendingEvent!);
              pendingEvent = null;

              setState(() {
                chatNotification = notifText;
                hasUnreadNotification = true;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(notifText),
                  duration: Duration(seconds: 3),
                ),
              );
            });
          }
        },
  child: Icon(Icons.add),
)

    );
  }
}
