import 'package:flutter/material.dart';
import '/constants.dart';
import '/data/models/program_model.dart';

class ProgramDetailScreen extends StatelessWidget {
  final Program program;
  
  const ProgramDetailScreen({Key? key, required this.program}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar with program header image
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                program.name,
                style: const TextStyle(
                  color: kWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Header Image
                  program.programHeaderPhoto != null
                    ? Image.network(
                        program.programHeaderPhoto!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: kGreenGradient,
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
          
          // Program Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Program Logo and Basic Info
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Program Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: program.logo != null
                            ? Image.network(
                                program.logo!,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text(
                                  program.name.length > 1
                                    ? program.name.substring(0, 2).toUpperCase()
                                    : program.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: kGreen1,
                                  ),
                                ),
                              ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Program Name and Type
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              program.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: kGreen1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              program.programType,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Director name if available
                            if (program.directorName != null)
                              Row(
                                children: [
                                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Director: ${program.directorName}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Stats Card (Total Events and Average Rating)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: kMint.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Total Events
                      Row(
                        children: [
                          Icon(Icons.event, color: kGreen1),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Events',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.brown,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${program.totalEvents} events',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: kGreen1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Average Rating (Hardcoded for now)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Average Rating',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.brown,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '4.5 stars',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: kGreen1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Program Status and Dates
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Status Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: program.programStatus.toLowerCase() == 'active' || 
                                 program.programStatus.toLowerCase() == 'on-going'
                              ? Colors.green.withOpacity(0.2)
                              : Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          program.programStatus,
                          style: TextStyle(
                            fontSize: 12,
                            color: program.programStatus.toLowerCase() == 'active' || 
                                  program.programStatus.toLowerCase() == 'on-going'
                                ? Colors.green[800]
                                : Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Establishment Date
                      if (program.establishmentDate.isNotEmpty)
                        Text(
                          'Established: ${program.establishmentDate}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Description Header
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                  child: Text(
                    'About This Program',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kGreen1,
                    ),
                  ),
                ),
                
                // Description Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    program.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
                
                // Upcoming Events Header
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kGreen1,
                    ),
                  ),
                ),
                
                // Placeholder for Events (Coming Soon)
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_note,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No upcoming events found',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Check back later for updates',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom spacing
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}