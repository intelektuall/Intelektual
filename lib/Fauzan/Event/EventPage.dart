import 'package:sopan_santun_app/Fauzan/Event/Providers/event_model.dart';
import '/Fauzan/Event/EventAdd.dart';
import '/Fauzan/Event/Widget/custom_dropdown.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/event_provider.dart';
import 'Notification/notification_provider.dart';
import 'NotificationPage.dart';

class EventLautPage extends StatefulWidget {
  const EventLautPage({super.key});

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final eventProvider = context.read<EventProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.blueAccent,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                tooltip: 'Inbox Chat',
                onPressed: () {
                  setState(() {
                    hasUnreadNotification = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationPage()),
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
                    decoration: const BoxDecoration(
                      color: Colors.red,
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
                const SizedBox(width: 12),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Switch(
                  value: showJoinedOnly,
                  onChanged: (val) => setState(() => showJoinedOnly = val),
                  activeColor: colorScheme.primary,
                ),
                const Text("Tampilkan yang diikuti"),
              ],
            ),
            const SizedBox(height: 12),

            // === FutureBuilder untuk menampilkan event dari DB ===
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: eventProvider
                    .loadEvents(), // loadEvents sudah return List<Event>
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Tidak ada event ditemukan"),
                    );
                  }

                  final filteredEvents = snapshot.data!.where((event) {
                    if (selectedLocation != null &&
                        event.location != selectedLocation) {
                      return false;
                    }
                    if (selectedCategory != null &&
                        event.category != selectedCategory) {
                      return false;
                    }
                    if (showJoinedOnly && !event.joined) return false;
                    return true;
                  }).toList();

                  return ListView.separated(
                    itemCount: filteredEvents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final event = filteredEvents[index];
                      return ExpansionTileCard(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(12),
                        baseColor: theme.cardColor,
                        title: Text(
                          event.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
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
                                const SizedBox(height: 12),
                                Text(
                                  event.joined
                                      ? "Kamu telah bergabung di event ini."
                                      : "Ingin bergabung dalam event ini?",
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await eventProvider.toggleJoin(event);
                                        setState(() {});
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: event.joined
                                            ? colorScheme.error
                                            : colorScheme.primary,
                                      ),
                                      child: Text(
                                        event.joined ? "Batalkan" : "Gabung",
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        if (event.id != null) {
                                          await eventProvider.deleteEvent(
                                            event.id!,
                                          );
                                          setState(
                                            () {},
                                          ); // refresh FutureBuilder
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // FAB untuk tambah event
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

              context.read<NotificationProvider>().addNotification(
                nama,
                lokasi,
              );
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
      ),
    );
  }
}
