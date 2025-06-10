import 'package:flutter/material.dart';
import '../constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> images = [
    'assets/images/onboarding1.png',
    'assets/images/onboarding2.png',
    'assets/images/onboarding3.png',
  ];
  void _skipToEnd() {
    Navigator.pushReplacementNamed(context, '/get_started');
  }

  void _nextPage() {
    if (_currentIndex < images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _skipToEnd(); // You can reuse the same function when onboarding completes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView that takes up the full screen
          SizedBox.expand(
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: _currentIndex == index ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Dot indicators at the bottom left
          Positioned(
            bottom: 30,
            left: 30,
            child: Row(
              children: List.generate(images.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentIndex == index
                            ? null
                            : kGreen1.withOpacity(0.5),
                    gradient: _currentIndex == index ? kGreenGradient : null,
                  ),
                );
              }),
            ),
          ),

          // Next button with gradient at the bottom right
          Positioned(
            bottom: 20,
            right: 20,
            child: GreenGradientButton(
              text: 'NEXT',
              onPressed: _nextPage,
              width: 100,
              height: 40,
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: kWhite,
              ),
              icon: Icons.arrow_forward,
              iconSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
