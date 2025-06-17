import 'package:flutter/material.dart';
import '/constants.dart';
import '/data/models/event_model.dart';
import 'package:provider/provider.dart';
import '/providers/event_provider.dart';
import './event_detail_screen.dart';

class HomeEventsSection extends StatelessWidget {
  const HomeEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Latest Events',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kGreen1,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all events page
                },
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        eventProvider.isLoading
            ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(child: CircularProgressIndicator(color: kGreen1)),
            )
            : eventProvider.error != null
            ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Failed to load events',
                      style: TextStyle(color: Colors.red[800]),
                    ),
                    ElevatedButton(
                      onPressed: () => eventProvider.fetchEvents(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
            : eventProvider.events.isEmpty
            ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Center(child: Text('No upcoming events available')),
            )
            : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: eventProvider.events.length,
                itemBuilder: (context, index) {
                  return _buildEventCard(context, eventProvider.events[index]);
                },
              ),
            ),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 120,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(color: kMint.withOpacity(0.5)),
                child:
                    event.poster != null
                        ? Image.network(event.poster!, fit: BoxFit.cover)
                        : Center(
                          child: Icon(
                            Icons.calendar_today,
                            size: 40,
                            color: kGreen1,
                          ),
                        ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kGreen1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.formattedTime ?? 'TBA',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.eventLocation ?? 'TBA',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          event.programLogo != null
                              ? Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(event.programLogo!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                              : const Icon(
                                Icons.business,
                                size: 16,
                                color: Colors.grey,
                              ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.programName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
