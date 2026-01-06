import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/event_provider.dart';
import '../Notification/notification_provider.dart';

class EventCardContent extends StatelessWidget {
  final Event event;
  final VoidCallback onNotify;

  const EventCardContent({
    super.key,
    required this.event,
    required this.onNotify,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.date != null)
            Text(
              "Tanggal: ${event.date!.day}/${event.date!.month}/${event.date!.year}",
              style: theme.textTheme.bodySmall,
            ),
          if (event.startTime != null && event.endTime != null)
            Text(
              "Waktu: ${event.startTime} - ${event.endTime}",
              style: theme.textTheme.bodySmall,
            ),
          const SizedBox(height: 12),
          Text(
            event.joined
                ? "Kamu telah bergabung di event ini."
                : "Ingin bergabung dalam event ini?",
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                final wasJoined = event.joined;
                context.read<EventProvider>().toggleJoin(event);

                if (!wasJoined) {
                  context.read<NotificationProvider>().addJoinNotification(
                    event.title,
                    event.location,
                  );
                  onNotify();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Anda bergabung ke event ${event.title}"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Anda membatalkan keikutsertaan di ${event.title}",
                      ),
                    ),
                  );
                }
              },
              child: Text(event.joined ? "Batalkan" : "Gabung"),
            ),
          ),
        ],
      ),
    );
  }
}
