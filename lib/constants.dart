import 'package:flutter/material.dart';

//#------- Solid Colors -------#
const Color kGreen1 = Color(0xFF003D2B); // Green
const Color kGreen2 = Color(0xFF21A179); // Light Green
const Color kMint = Color(0xFFE4F1EA); // Lightest Green
const Color kBrown = Color(0xFFA24E43); // Brown
const Color kBrown1 = Color(0xFF6A2117); // Dark Brown
const Color kBlack = Color(0xFF141414); // Black
const Color kWhite = Color(0xFFFFFFFF); // White

//#------- Gradient Colors -------#
const LinearGradient kGreenGradient1 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF003D2B), Color(0xFF00A373)],
);
const LinearGradient kGreenGradient2 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF21A179), Color(0xFFE4F1EA)],
);
const LinearGradient kBrownGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF6A2117), Color(0xFFA24E43)],
);

// Spacing & Layout
const double defaultPadding = 16.0;

// API URLs
const String kApiBaseUrl =
    'http://localhost:8000'; // Replace with your actual API URL

// Complete TextField styling
final InputDecoration authInputDecoration = InputDecoration(
  filled: true,
  fillColor: kWhite,
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(
    vertical: 12,
    horizontal: 12,
  ), // Tighter padding
  labelStyle: TextStyle(
    color: Color.fromARGB(
      128,
      kGreen1.red,
      kGreen1.green,
      kGreen1.blue,
    ), // 50% opacity
    fontSize: 12, // Smaller label
  ),
  // Border states
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(
      color: Color.fromARGB(
        (255 * 0.2).round(),
        kGreen1.red,
        kGreen1.green,
        kGreen1.blue,
      ),
      width: 1.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(
      color: Color.fromARGB(
        (255 * 0.2).round(),
        kGreen1.red,
        kGreen1.green,
        kGreen1.blue,
      ),
      width: 1.0,
    ),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: BorderSide(
      color: Color.fromARGB(
        (255 * 0.2).round(),
        kGreen1.red,
        kGreen1.green,
        kGreen1.blue,
      ),
      width: 1.0,
    ),
  ),
);

// Gradient Text Widget
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText({
    super.key,
    required this.text,
    required this.style,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(text, style: style),
    );
  }
}

// Green Gradient Button
class GreenGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final IconData? icon;
  final double? iconSize;

  const GreenGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.textStyle,
    this.padding,
    this.borderRadius = 6,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding:
                padding ??
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              gradient: kGreenGradient1,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style:
                      textStyle ??
                      const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kWhite,
                      ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 4),
                  Icon(icon, size: iconSize ?? 16, color: kWhite),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
