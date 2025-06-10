// import 'package:flutter/material.dart';
// import 'package:cylcentral/constants.dart';
// import 'package:cylcentral/models/event.dart';
// import 'package:cylcentral/services/mock_data_service.dart';
// import 'package:cylcentral/Screens/mem_event_details.dart';
// import 'package:cylcentral/data/models/user_model.dart';

// class ProgramEventsScreen extends StatefulWidget {
//   final String program;
//   final User? user;

//   const ProgramEventsScreen({
//     super.key,
//     required this.program,
//     this.user,
//   });

//   @override
//   State<ProgramEventsScreen> createState() => _ProgramEventsScreenState();
// }

// class _ProgramEventsScreenState extends State<ProgramEventsScreen> {
//   List<Event> _events = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadEvents();
//   }

//   Future<void> _loadEvents() async {
//     try {
//       final allEvents = await MockDataService.getEvents();
//       setState(() {
//         _events = allEvents.where((e) => e.program == widget.program).toList();
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error loading events: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.program,
//           style: const TextStyle(
//             fontSize: 16,
//             color: kWhite,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: kGreenGradient,
//           ),
//         ),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: kWhite),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _events.isEmpty
//               ? Center(
//                   child: Text(
//                     'No events found for ${widget.program}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 )
//               : ListView.builder(
//                   padding: const EdgeInsets.all(16.0),
//                   itemCount: _events.length,
//                   itemBuilder: (context, index) {
//                     final event = _events[index];
//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 16.0),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MemEventDetails(
//                                 event: event,
//                                 user: widget.user,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: 150,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: AssetImage(event.imagePath),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     event.episode,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.calendar_today, size: 16),
//                                       const SizedBox(width: 8),
//                                       Text(event.details['Date'] ?? 'TBA'),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.location_on, size: 16),
//                                       const SizedBox(width: 8),
//                                       Text(event.details['Venue'] ?? 'TBA'),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.star, color: Colors.amber),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         event.rating.toStringAsFixed(1),
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Text(event.reviewCount),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
