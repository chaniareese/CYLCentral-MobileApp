// import 'package:flutter/material.dart';
// import 'package:cylcentral/constants.dart';

// // Reusable Event Card
// class EventCard extends StatelessWidget {
//   final String date;
//   final String title;
//   final String location;

//   const EventCard({
//     super.key,
//     required this.date,
//     required this.title,
//     required this.location,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: kWhite,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             date,
//             style: TextStyle(
//               color: kGreen1,
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             location,
//             style: TextStyle(
//               color: kBlack.withOpacity(0.6),
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               'Details →',
//               style: TextStyle(
//                 color: kGreen2,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }