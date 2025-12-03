import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final List<BottomNavBarItem> items;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - (screenWidth * 0.03);
    final pillWidth = availableWidth / items.length;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/appbarbackground.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.015,
            horizontal: screenWidth * 0.015,
          ),

          // STACK = bubble + icons
          child: SizedBox(
            height: 54,
            child: Stack(
              children: [
               
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  left: currentIndex * pillWidth,
                  child: _LiquidGlassPill(width: pillWidth),
                ),

                // 🔵 Icons + labels on top - wrapped in Flexible to prevent overflow
                Positioned.fill(
                  child: Row(
                    children: items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onTabTapped(index),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                size: screenWidth * 0.080,
                                color: index == currentIndex
                                    ? Colors.white
                                    : Colors.white70,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.label,
                                style: GoogleFonts.montserrat(
                                  fontSize: 9,
                                  fontWeight: index == currentIndex
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                                  color: index == currentIndex
                                      ? Colors.white
                                      : Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidGlassPill extends StatelessWidget {
  final double width;

  const _LiquidGlassPill({required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: width,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),

            // Apple liquid glass = translucent white + slight border + highlight gradient
            color: Colors.white.withOpacity(0.18),
            border: Border.all(
              color: Colors.white.withOpacity(0.28),
              width: 1.2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.26), // highlight
                Colors.white.withOpacity(0.06), // depth
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavBarItem {
  final IconData icon;
  final String label;

  BottomNavBarItem({required this.icon, required this.label});
}