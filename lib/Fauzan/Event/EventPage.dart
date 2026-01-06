import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'EventAdd.dart';
import 'EventDataList/event_constants.dart';
import 'Providers/event_provider.dart';
import 'Notification/notification_provider.dart';
import 'NotificationPage.dart';

// NEW (hasil refactor)
import 'Helpers/event_location_helper.dart';
import 'Widget/event_filter_section.dart';
import 'Widget/event_list_section.dart';

class EventLautPage extends StatefulWidget {
  @override
  State<EventLautPage> createState() => _EventLautPageState();
}

class _EventLautPageState extends State<EventLautPage> {
  String? selectedLocation;
  String? selectedCategory;
  bool showJoinedOnly = false;
  bool hasUnreadNotification = false;

  Event? pendingEvent;
  late Future<void> _loadingFuture;

  @override
  void initState() {
    super.initState();

    // simulasi loading awal
    _loadingFuture = _simulateLoading();

    // auto-detect lokasi (AMAN)
    EventLocationHelper.detectProvince(context).then((province) {
      if (!mounted) return;
      if (province != null) {
        setState(() => selectedLocation = province);
      }
    });
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        backgroundColor: Colors.blueAccent.withOpacity(0.7),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {
                  setState(() => hasUnreadNotification = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationPage()),
                  );
                },
              ),
              if (hasUnreadNotification)
                const Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(radius: 5, backgroundColor: Colors.red),
                ),
            ],
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// FILTER SECTION
            EventFilterSection(
              selectedLocation: selectedLocation,
              selectedCategory: selectedCategory,
              showJoinedOnly: showJoinedOnly,
              onLocationChanged: (val) {
                setState(() {
                  selectedLocation = val;
                  _loadingFuture = _simulateLoading();
                });
              },
              onCategoryChanged: (val) {
                setState(() {
                  selectedCategory = val;
                  _loadingFuture = _simulateLoading();
                });
              },
              onJoinedToggle: (val) {
                setState(() {
                  showJoinedOnly = val;
                  _loadingFuture = _simulateLoading();
                });
              },
            ),

            const SizedBox(height: 12),

            /// EVENT LIST
            Expanded(
              child: EventListSection(
                loadingFuture: _loadingFuture,
                selectedLocation: selectedLocation,
                selectedCategory: selectedCategory,
                showJoinedOnly: showJoinedOnly,
                onNotify: () {
                  setState(() => hasUnreadNotification = true);
                },
              ),
            ),
          ],
        ),
      ),

      /// FAB ADD EVENT
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahEventPage()),
          );

          if (result == null || result['status'] != true) return;

          final nama = result['nama'];
          final kategori = result['kategori'];
          final lokasi = result['lokasi'];
          final kota = result['kota'];
          final tanggal = result['tanggal'] as DateTime?;
          final startTime = result['startTime'] as String?;
          final endTime = result['endTime'] as String?;

          pendingEvent = Event(
            title: nama,
            category: kategori,
            location: lokasi,
            city: kota,
            date: tanggal,
            startTime: startTime,
            endTime: endTime,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Event "$nama" sedang direview oleh tim kami.'),
            ),
          );

          /// SIMULASI APPROVE EVENT
          Future.delayed(const Duration(seconds: 5), () {
            if (!mounted || pendingEvent == null) return;

            context.read<EventProvider>().addEvent(pendingEvent!);
            context.read<NotificationProvider>().addNotification(
              pendingEvent!.title,
              pendingEvent!.location,
            );

            pendingEvent = null;

            setState(() {
              hasUnreadNotification = true;
              _loadingFuture = _simulateLoading();
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Event "$nama" telah disetujui!')),
            );
          });
        },
      ),
    );
  }
}
