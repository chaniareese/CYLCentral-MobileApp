import 'package:flutter/material.dart';
import '../constants.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/get_started.png',
              fit: BoxFit.cover,
            ),
          ),

          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // GET STARTED button (Gradient version)
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(6),
                    elevation: 0,
                    child: InkWell(
                      onTap: () {
                        // Navigation to LoginScreen using named route
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 290,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: kGreenGradient,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Text(
                            'GET STARTED',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: kWhite,
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
      ),
    );
  }
}
