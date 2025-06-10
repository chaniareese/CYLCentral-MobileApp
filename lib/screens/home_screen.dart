import 'package:flutter/material.dart';
import '/constants.dart';
import '/data/models/user_model.dart';
import '/data/models/program_model.dart';
import '/data/models/event_model.dart'; // Add event model import
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/program_provider.dart';
import '../providers/event_provider.dart'; // Add event provider import
import 'package:carousel_slider/carousel_slider.dart';
import './program_detail_screen.dart';
import './event_detail_screen.dart'; // Add event detail screen import

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _filteredEvents = [];
  int _currentCarouselIndex = 0;

  // Banner images for carousel
  final List<String> _bannerImages = [
    'assets/images/banner1.png',
    'assets/images/banner1.png', // For now using the same image for all three
    'assets/images/banner1.png', // Replace with banner2.png and banner3.png when available
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterEvents);

    // Fetch programs and events when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProgramProvider>(context, listen: false).fetchPrograms();
      Provider.of<EventProvider>(context, listen: false).fetchEvents(limit: 5); // Fetch latest events
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterEvents);
    _searchController.dispose();
    super.dispose();
  }

  void _filterEvents() {
    setState(() {
      // Filter events based on search
    });
  }

  @override
  Widget build(BuildContext context) {
    final programProvider = Provider.of<ProgramProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      backgroundColor: kMint,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 16,
            color: kWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: kGreenGradient),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message with Profile Picture
            // Replace the Welcome Message Container with this:
// Replace the Welcome Message with Profile Picture section with this code:
Container(
  padding: const EdgeInsets.all(16.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Welcome text on the left - with Expanded to prevent overflow
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Use Flexible to allow the text to shrink if needed
                Flexible(
                  child: Text(
                    'Hi, ${widget.user.firstName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kGreen1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(' 👋', style: TextStyle(fontSize: 24)),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'What\'s your plan today? Explore events!',
              style: TextStyle(fontSize: 16, color: Colors.brown),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      
      const SizedBox(width: 8), // Add spacing between text and profile picture
      
      // Profile Picture on the right
      CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey[200],
        backgroundImage:
            widget.user.profilePicture != null &&
                widget.user.profilePicture!.isNotEmpty
                ? NetworkImage(widget.user.profilePicture!)
                : null,
        child:
            (widget.user.profilePicture == null ||
                widget.user.profilePicture!.isEmpty)
                ? const Icon(
                  Icons.person,
                  size: 36,
                  color: Colors.grey,
                )
                : null,
      ),
    ],
  ),
),

            // Search and Filter Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      cursorColor: kGreen1,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kWhite,
                        hintText: 'Search Event',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: kGreen1.withOpacity(0.5),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 18,
                          color: kGreen1.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 12, color: kBlack),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      // Implement filter/sort function
                    },
                    icon: const Icon(
                      Icons.filter_alt,
                      size: 22,
                      color: kGreen1,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Banner Carousel with horizontal padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 150, 
                  width: double.infinity,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                      height: 150,
                      padEnds: false,
                    ),
                    items: _bannerImages.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width - 32, 
                            child: Image.asset(
                              item,
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.center,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Carousel Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _bannerImages.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentCarouselIndex == entry.key
                        ? kGreen1
                        : kGreen1.withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Programs Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Explore Our Programs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kGreen1,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all programs page
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

            const SizedBox(height: 10),
            
            // Programs Horizontal List
            SizedBox(
              height: 180, // Reduced height for smaller cards
              child: programProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: kGreen1),
                  )
                : programProvider.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Failed to load programs',
                            style: TextStyle(color: Colors.red[800]),
                          ),
                          ElevatedButton(
                            onPressed: () => programProvider.fetchPrograms(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : programProvider.programs.isEmpty
                    ? const Center(child: Text('No programs available'))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: programProvider.programs.length,
                        itemBuilder: (context, index) {
                          final program = programProvider.programs[index];
                          return _buildProgramCard(program);
                        },
                      ),
            ),

            const SizedBox(height: 20),

            // Latest Events Section Header
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

            // Latest Events List
            eventProvider.isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: CircularProgressIndicator(color: kGreen1)),
                )
              : eventProvider.error != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
                      child: Center(
                        child: Text('No upcoming events available'),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: eventProvider.events.length,
                        itemBuilder: (context, index) {
                          return _buildEventCard(eventProvider.events[index]);
                        },
                      ),
                    ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Program card builder - redesigned card with header on top half and text in bottom half
  Widget _buildProgramCard(Program program) {
    return GestureDetector(
      onTap: () {
        // Navigate to program details
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProgramDetailScreen(program: program),
          ),
        );
      },
      child: Container(
        width: 200, // Reduced width for a more compact card
        margin: const EdgeInsets.only(right: 12),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top half with program header image and logo
            Stack(
              alignment: Alignment.center,
              children: [
                // Program Header Photo as background (top half only)
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: SizedBox(
                    height: 90, // Half the card height for the image
                    child: program.programHeaderPhoto != null 
                      ? Image.network(
                          program.programHeaderPhoto!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Container(color: kMint),
                  ),
                ),
                
                // Program Logo overlay in circle
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 0,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kGreen1,
                            ),
                          ),
                        ),
                  ),
                ),
              ],
            ),
            
            // Bottom half with text content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Program Name
                  Text(
                    program.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kGreen1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Program Description
                  Text(
                    program.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Event card builder
  Widget _buildEventCard(Event event) {
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
              // Left side - Event Poster
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: kMint.withOpacity(0.5),
                ),
                child: event.poster != null
                  ? Image.network(
                      event.poster!,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Icon(
                        Icons.calendar_today,
                        size: 40,
                        color: kGreen1,
                      ),
                    ),
              ),
              
              // Right side - Event Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date
                      Text(
                        event.formattedDate,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      
                      // Title
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
                      
                      // Time and Location
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.grey),
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
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
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
                      
                      // Program name with logo
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
                            : const Icon(Icons.business, size: 16, color: Colors.grey),
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