import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/event_provider.dart';
import 'event_expansion_card.dart';

class EventListSection extends StatelessWidget {
  final Future<void> loadingFuture;
  final String? selectedLocation;
  final String? selectedCategory;
  final bool showJoinedOnly;
  final VoidCallback onNotify;

  const EventListSection({
    super.key,
    required this.loadingFuture,
    required this.selectedLocation,
    required this.selectedCategory,
    required this.showJoinedOnly,
    required this.onNotify,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Consumer<EventProvider>(
          builder: (context, provider, _) {
            final events = provider.events.where((e) {
              if (selectedLocation != null && e.location != selectedLocation) {
                return false;
              }
              if (selectedCategory != null && e.category != selectedCategory) {
                return false;
              }
              if (showJoinedOnly && !e.joined) return false;
              return true;
            }).toList();

            if (events.isEmpty) {
              return const Center(child: Text("Tidak ada event ditemukan"));
            }

            return ListView.separated(
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) =>
                  EventExpansionCard(event: events[i], onNotify: onNotify),
            );
          },
        );
      },
    );
  }
}
