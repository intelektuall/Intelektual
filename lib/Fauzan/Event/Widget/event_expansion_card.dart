import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import '../Providers/event_provider.dart';
import 'event_card_content.dart';

class EventExpansionCard extends StatelessWidget {
  final Event event;
  final VoidCallback onNotify;

  const EventExpansionCard({
    super.key,
    required this.event,
    required this.onNotify,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTileCard(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      title: Text(event.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.location),
          Text(event.city),
          Text(
            event.category,
            style: const TextStyle(color: Colors.blueAccent),
          ),
        ],
      ),
      children: [EventCardContent(event: event, onNotify: onNotify)],
    );
  }
}
