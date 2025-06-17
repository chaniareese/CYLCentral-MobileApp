import 'package:flutter/material.dart';
import 'dart:async';
import '../../constants.dart';

//============================================================================
// MODEL - Data Structure
//============================================================================
/// Data model for onboarding page content
/// Contains the image path, title, and description for each page
class OnboardPage {
  final String gif, title, desc;
  OnboardPage(this.gif, this.title, this.desc);
}

//============================================================================
// CONTROLLER & UI - Main Onboarding Screen Widget
//============================================================================
/// Main onboarding screen with auto-scrolling pages and navigation
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

//============================================================================
// CONTROLLER - State Management and Logic
//============================================================================

class _OnboardingScreenState extends State<OnboardingScreen> {
  //---------- Controller Properties ----------//
  final PageController _pageController =
      PageController(); // Controls page navigation
  int _currentIndex = 0; // Tracks current active page (0-3)
  Timer? _autoScrollTimer; // Timer for automatic page scrolling

  //---------- Model Data ----------//
  /// Static list containing all onboarding page content
  /// Each page has an image, title, and description
  final List<OnboardPage> pages = [
    OnboardPage(
      'assets/images/onboarding/onboarding1.gif',
      'Grow Your Skills with CYLC',
      'Explore workshops, webinars, and volunteer programs—all in one place.',
    ),
    OnboardPage(
      'assets/images/onboarding/onboarding2.gif',
      'Smarter Event Experience',
      'Scan to check in, get instant e-certificates, and rate your experience.',
    ),
    OnboardPage(
      'assets/images/onboarding/onboarding3.gif',
      'Ready to Lead?',
      'Your journey starts now. Connect, grow, and make an impact with CYLC.',
    ),
    OnboardPage(
      'assets/images/logo_name.png',
      '', // Empty string to fulfill argument requirement
      "Cordillera Young Leaders Club's Official Event Platform",
    ),
  ];

  /// Background images for different page types
  final String onboardingBg = 'assets/images/onboarding/onboarding_bg.png';
  final String welcomeBg = 'assets/images/onboarding/welcome_bg.png';

  //---------- Controller Methods - Navigation ----------//
  /// Moves to next page or completes onboarding if on last page
  void _nextPage() {
    if (_currentIndex < 3) {
      // Only allow next for the first 3 pages
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  //---------- Controller Methods - Auto-Scroll Timer ----------//
  /// Starts a timer to auto-scroll to the next page.
  /// Stops at page 2 to prevent skipping to the welcome screen.
  void _startOrResetAutoScrollTimer() {
    _autoScrollTimer?.cancel();
    if (_currentIndex < 2) {
      _autoScrollTimer = Timer(const Duration(seconds: 5), () {
        if (_currentIndex < 2) _nextPage();
      });
    }
  }

  //---------- Controller Lifecycle ----------//
  @override
  void initState() {
    super.initState();
    _startOrResetAutoScrollTimer(); // Start auto-scroll on screen load
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  //============================================================================
  // UI - Main Screen Layout
  //============================================================================
  @override
  Widget build(BuildContext context) {
    final isWelcome = _currentIndex == 3; // Check if currently on welcome page

    return Scaffold(
      body: Stack(
        children: [
          //---------- UI Layer 1: Dynamic Background Image ----------//
          Positioned.fill(
            child: Image.asset(
              // Use different background for welcome page vs onboarding pages
              isWelcome ? welcomeBg : onboardingBg,
              fit: BoxFit.cover,
            ),
          ),

          //---------- UI Layer 2: Page Content with Scroll Detection ----------//
          NotificationListener<ScrollNotification>(
            // Reset auto-scroll timer when user manually scrolls
            onNotification: (notification) {
              _startOrResetAutoScrollTimer();
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length, // Total of 4 pages
              onPageChanged: (i) {
                // Called when page changes
                setState(() => _currentIndex = i); // Update current page index
                _startOrResetAutoScrollTimer(); // Reset timer on page change
              },
              // Disable scrolling on welcome page, enable bouncing scroll on others
              physics:
                  isWelcome
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
              itemBuilder:
                  (context, i) => _OnboardContent(
                    page: pages[i],
                    visible: _currentIndex == i,
                  ),
            ),
          ),

          //---------- UI Layer 3: Page Indicator Dots (Pages 0-2 only) ----------//
          if (!isWelcome)
            Positioned(
              bottom: 30,
              left: 30,
              child: Row(
                children: List.generate(
                  3,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Active dot: gradient, Inactive dot: semi-transparent
                      color:
                          _currentIndex == i ? null : kGreen1.withOpacity(0.5),
                      gradient: _currentIndex == i ? kGreenGradient1 : null,
                    ),
                  ),
                ),
              ),
            ),

          //---------- UI Layer 4: Next/Get Started Button (Pages 0-2 only) ----------//
          if (!isWelcome)
            Positioned(
              bottom: 20,
              right: 20,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: kGreenGradient1,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_currentIndex < 2) {
                      _nextPage();
                      _startOrResetAutoScrollTimer();
                    } else if (_currentIndex == 2) {
                      // On last intro page, go to welcome
                      _nextPage();
                    }
                  },
                  child: Text(
                    _currentIndex == 2 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: kWhite,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

//============================================================================
// UI - Individual Page Content Widget
//============================================================================

/// Displays content for a single onboarding page
/// Handles different layouts for intro pages vs welcome page
/// Features fade animation based on visibility
class _OnboardContent extends StatelessWidget {
  final OnboardPage page;
  final bool visible;
  const _OnboardContent({required this.page, required this.visible});

  @override
  Widget build(BuildContext context) {
    // Check if this is the welcome page by looking for logo in filename
    final isWelcome = page.gif.contains('logo_name.png');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          //---------- UI: Page Image with Animation ----------/
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child:
              isWelcome
                  ? Column(
                    children: [
                      Image.asset(page.gif, width: 220, fit: BoxFit.contain),
                      const SizedBox(height: 16),
                      Text(
                        page.desc,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: kGreen1,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  )
                  : Image.asset(
                    page.gif,
                    width: 350,
                    height: 350,
                    fit: BoxFit.contain,
                  ),
        ),
        const SizedBox(height: 32),

        //---------- UI: Page Title (Only for intro pages) ----------//
        if (!isWelcome)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kBrown1,
              ),
            ),
          ),

        if (!isWelcome) const SizedBox(height: 8),

        //---------- UI: Page Description (Only for intro pages) ----------//
        if (!isWelcome)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              page.desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: kBrown1,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

        //---------- UI: Login/Signup Buttons (Welcome page only) ----------//
        if (isWelcome) ...[
          const SizedBox(height: 300),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                // LOG IN button
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: kGreenGradient1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Navigate to login screen and remove onboarding from stack
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // SIGN UP button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: kGreenGradient1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kMint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Navigate to registration screen and remove onboarding from stack
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return kGreenGradient1.createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            );
                          },
                          blendMode: BlendMode.srcIn,
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
