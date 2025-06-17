import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '/constants.dart';
import '/data/models/user_model.dart';
import '/providers/event_provider.dart';
import '/providers/program_provider.dart';
import '/providers/notification_provider.dart';
import './home_programs_section.dart';
import './home_events_section.dart';
import '../member/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Banner images for carousel
  final List<String> _bannerImages = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
    'assets/images/banner4.png',
  ];

  // Placeholder URLs for banners (replace with real links later)
  final List<String> _bannerLinks = [
    'https://your-website-link-1.com',
    'https://your-website-link-2.com',
    'https://your-website-link-3.com',
    'https://your-website-link-4.com',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterEvents);
    // Ensure providers fetch data on home screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProgramProvider>(context, listen: false).fetchPrograms();
      Provider.of<EventProvider>(context, listen: false).fetchEvents(limit: 5);
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).fetchUnreadCount();
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
          decoration: const BoxDecoration(gradient: kGreenGradient1),
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
                  // Profile Picture on the left
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
                  const SizedBox(width: 16),
                  // Welcome text and subtitle in the middle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
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
                          style: TextStyle(fontSize: 14, color: Colors.brown),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Notification bell for members/participants only
                  if (widget.user.role == 'Member' ||
                      widget.user.role == 'Participant')
                    Consumer<NotificationProvider>(
                      builder: (context, notifProvider, _) {
                        final unread = notifProvider.unreadCount;
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => const NotificationsScreen(),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Icon(
                                Icons.notifications,
                                color: kGreen1,
                                size: 36,
                              ),
                              if (unread > 0)
                                Positioned(
                                  right: 0,
                                  top: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF9B4841),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 2,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 20,
                                      minHeight: 20,
                                    ),
                                    child: Center(
                                      child: Text(
                                        unread.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
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
                      height: 150,
                      padEnds: false,
                    ),
                    items: List.generate(_bannerImages.length, (i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                debugPrint(
                                  'Banner tapped: \\${_bannerLinks[i]}',
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 32,
                                child: Image.asset(
                                  _bannerImages[i],
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),
            ),

            // const SizedBox(height: 10),

            // Carousel Indicators (removed)
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children:
            //       _bannerImages.asMap().entries.map((entry) {
            //         return Container(
            //           width: 8.0,
            //           height: 8.0,
            //           margin: const EdgeInsets.symmetric(horizontal: 4.0),
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color:
            //                 _currentCarouselIndex == entry.key
            //                     ? kGreen1
            //                     : kGreen1.withOpacity(0.3),
            //           ),
            //         );
            //       }).toList(),
            // ),
            const SizedBox(height: 20),

            // Programs Section
            const HomeProgramsSection(),

            const SizedBox(height: 20),

            // Events Section
            const HomeEventsSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
