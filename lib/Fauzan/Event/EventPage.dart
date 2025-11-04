import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopan_santun_app/Fauzan/Event/EventAdd.dart';
import 'package:sopan_santun_app/Fauzan/Event/Widget/custom_dropdown.dart';
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

  late Future<void> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _loadingFuture = _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(
      Duration(seconds: 2),
    ); // Delay 2 detik simulasi loading
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events'),
        backgroundColor: Colors.blueAccent.withOpacity(0.7),
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
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown & Switch
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
                        _loadingFuture = _simulateLoading();
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
                        _loadingFuture = _simulateLoading();
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
                  onChanged: (val) {
                    setState(() {
                      showJoinedOnly = val;
                      _loadingFuture = _simulateLoading();
                    });
                  },
                  activeColor: Colors.blueAccent,
                ),
                Text("Tampilkan yang diikuti"),
              ],
            ),
            SizedBox(height: 12),

            // FutureBuilder untuk efek delay
            Expanded(
              child: FutureBuilder<void>(
                future: _loadingFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.blueAccent),
                          SizedBox(height: 12),
                          Text("Memuat event..."),
                        ],
                      ),
                    );
                  }

                  // Setelah delay selesai, tampilkan data dari Provider
                  return Consumer<EventProvider>(
                    builder: (context, provider, _) {
                      final events = provider.events;
                      final filteredEvents = events.where((event) {
                        if (selectedLocation != null &&
                            event.location != selectedLocation)
                          return false;
                        if (selectedCategory != null &&
                            event.category != selectedCategory)
                          return false;
                        if (showJoinedOnly && !event.joined) return false;
                        return true;
                      }).toList();

                      if (filteredEvents.isEmpty) {
                        return Center(child: Text("Tidak ada event ditemukan"));
                      }

                      return ListView.separated(
                        itemCount: filteredEvents.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final event = filteredEvents[index];
                          return ExpansionTileCard(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(12),
                            baseColor: Colors.blue[50],
                            title: Text(
                              event.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${event.location} · ${event.category}",
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
                                      ),
                                    if (event.startTime != null &&
                                        event.endTime != null)
                                      Text(
                                        "Waktu: ${event.startTime} - ${event.endTime}",
                                      ),
                                    SizedBox(height: 12),
                                    Text(
                                      event.joined
                                          ? "Kamu telah bergabung di event ini."
                                          : "Ingin bergabung dalam event ini?",
                                    ),
                                    SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          final wasJoined = event.joined;
                                          context
                                              .read<EventProvider>()
                                              .toggleJoin(event);

                                          if (!wasJoined) {
                                            // Tambahkan delay sebelum memunculkan titik merah notif
                                            Future.delayed(
                                              Duration(seconds: 1),
                                              () {
                                                context
                                                    .read<
                                                      NotificationProvider
                                                    >()
                                                    .addJoinNotification(
                                                      event.title,
                                                      event.location,
                                                    );

                                                setState(() {
                                                  hasUnreadNotification = true;
                                                });
                                              },
                                            );

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Anda bergabung ke event ${event.title}",
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          } else {
                                            // User membatalkan keikutsertaan
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Anda membatalkan keikutsertaan di ${event.title}",
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },

                                        style: TextButton.styleFrom(
                                          foregroundColor: event.joined
                                              ? Colors.redAccent
                                              : Colors.blueAccent,
                                        ),
                                        child: Text(
                                          event.joined ? "Batalkan" : "Gabung",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
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
                content: Text('Event "$nama" sedang direview oleh tim kami.'),
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
                _loadingFuture = _simulateLoading(); // refresh tampil
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
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
