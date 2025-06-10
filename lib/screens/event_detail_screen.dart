import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/constants.dart';
import '/data/models/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;
  
  const EventDetailScreen({Key? key, required this.event}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar with event poster
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                event.title,
                style: const TextStyle(
                  color: kWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Event Poster
                  event.poster != null
                    ? Image.network(
                        event.poster!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: kGreenGradient,
                        ),
                        child: const Icon(
                          Icons.event,
                          color: kWhite,
                          size: 60,
                        ),
                      ),
                  // Gradient overlay for better text visibility
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Event Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date, Time and Location Card
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
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
                  child: Column(
                    children: [
                      // Date and Time
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kMint,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: kGreen1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.formattedDate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (event.formattedTime != null)
                                  Text(
                                    event.formattedTime!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const Divider(height: 24),
                      
                      // Location
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kMint,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: kGreen1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.eventFormat?.toUpperCase() ?? 'VENUE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  event.eventLocation ?? 'To be announced',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                if (event.eventFormat == 'online' && event.eventPlatform != null)
                                  Text(
                                    'Platform: ${event.eventPlatform}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      // Join link if online event
                      if (event.eventFormat == 'online' && event.eventLink != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (event.eventLink != null) {
                                final Uri url = Uri.parse(event.eventLink!);
                                if (await canLaunchUrl(url)) {
                                  launchUrl(url);
                                }
                              }
                            },
                            icon: const Icon(Icons.videocam),
                            label: const Text('Join Online Event'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kGreen1,
                              foregroundColor: kWhite,
                              minimumSize: const Size(double.infinity, 40),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Program info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Program Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: event.programLogo != null
                            ? Image.network(event.programLogo!, fit: BoxFit.cover)
                            : Container(
                                color: kMint,
                                child: const Icon(Icons.business, color: kGreen1),
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Program Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Organized by:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              event.programName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kGreen1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Registration Info
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: event.isFree ? Colors.green.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: event.isFree ? Colors.green.withOpacity(0.3) : Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        event.isFree ? Icons.card_giftcard : Icons.payment,
                        color: event.isFree ? Colors.green : Colors.amber[800],
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.isFree ? 'FREE ENTRY' : 'PAID REGISTRATION',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: event.isFree ? Colors.green[700] : Colors.amber[800],
                              ),
                            ),
                            if (!event.isFree && event.registrationFee != null)
                              Text(
                                'Fee: ₱${event.registrationFee!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                ),
                              ),
                            if (event.memberonlyRegis)
                              Text(
                                'For members only',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Event Description Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'About This Event',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kGreen1,
                    ),
                  ),
                ),
                
                // Event Description
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
                
                // Inclusions if any
                if (event.inclusions != null && event.inclusions!.isNotEmpty) 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'What\'s Included',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kGreen1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.inclusions!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Event Head
                if (event.eventHeadName != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: kGreen1),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Event Head',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              event.eventHeadName!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                
                // Bottom padding
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}