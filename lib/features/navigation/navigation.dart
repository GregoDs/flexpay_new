import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatefulWidget {
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
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> 
    with TickerProviderStateMixin {
  double dragOffset = 0;
  late int currentIndex;
  late AnimationController _pillController;
  late AnimationController _rippleController;
  late Animation<double> _pillAnimation;
  late Animation<double> _rippleAnimation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    dragOffset = currentIndex.toDouble();
    
    // Pill movement animation controller
    _pillController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    // Ripple/water effect controller
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _pillAnimation = CurvedAnimation(
      parent: _pillController,
      curve: Curves.elasticOut,
    );
    
    _rippleAnimation = CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pillController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex && !_isDragging) {
      _animateToIndex(widget.currentIndex);
    }
  }

  void _animateToIndex(int index) {
    setState(() {
      currentIndex = index;
    });
    
    final targetOffset = index.toDouble();
    final animation = Tween<double>(
      begin: dragOffset,
      end: targetOffset,
    ).animate(_pillAnimation);
    
    animation.addListener(() {
      setState(() {
        dragOffset = animation.value;
      });
    });
    
    _pillController.forward(from: 0);
    _rippleController.forward(from: 0);
  }

  void _onTap(int index) {
    if (index != currentIndex) {
      _animateToIndex(index);
      widget.onTabTapped(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - (screenWidth * 0.03);
    final pillWidth = availableWidth / widget.items.length;

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
            vertical: screenWidth * 0.020,
            horizontal: screenWidth * 0.015,
          ),
          child: SizedBox(
            height: 64, 
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (details) {
                _isDragging = true;
                _pillController.stop();
                _rippleController.stop();
              },
              onHorizontalDragUpdate: (details) {
                setState(() {
                  // High-performance drag calculation with momentum
                  final sensitivity = 1.2; // Increase for more responsive drag
                  dragOffset += (details.delta.dx / pillWidth) * sensitivity;
                  dragOffset = dragOffset.clamp(0.0, widget.items.length - 1.0);
                });
              },
              onHorizontalDragEnd: (details) {
                _isDragging = false;
                
                // Calculate velocity for natural iOS-like momentum
                final velocity = details.velocity.pixelsPerSecond.dx;
                var targetIndex = dragOffset.round();
                
                // Add momentum-based overshoot like iOS
                if (velocity.abs() > 300) {
                  if (velocity > 0 && targetIndex < widget.items.length - 1) {
                    targetIndex++;
                  } else if (velocity < 0 && targetIndex > 0) {
                    targetIndex--;
                  }
                }
                
                targetIndex = targetIndex.clamp(0, widget.items.length - 1);
                _animateToIndex(targetIndex);
                widget.onTabTapped(targetIndex);
              },
              child: Stack(
                children: [
                  // Water ripple effect background
                  if (_rippleAnimation.value > 0)
                    Positioned(
                      left: dragOffset * pillWidth + (pillWidth / 2) - 35,
                      top: 36 - 35, // Adjusted for new height
                      child: AnimatedBuilder(
                        animation: _rippleAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 70 * (1 + _rippleAnimation.value * 0.5),
                            height: 70 * (1 + _rippleAnimation.value * 0.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(
                                0.1 * (1 - _rippleAnimation.value),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // Enhanced liquid pill with better performance
                  Positioned(
                    left: dragOffset * pillWidth,
                    top: 8, // Added top positioning to center the pill properly
                    child: _EnhancedLiquidPill(
                      width: pillWidth,
                      isDragging: _isDragging,
                      animationValue: _isDragging ? 1.0 : _pillAnimation.value,
                    ),
                  ),

                  // Icons with smooth color transitions
                  Positioned.fill(
                    child: Row(
                      children: widget.items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final distance = (dragOffset - index).abs();
                        final isActive = distance < 0.5;
                        
                        // Smooth color interpolation based on distance
                        final opacity = (1.0 - (distance * 0.7)).clamp(0.4, 1.0);
                        final iconColor = Color.lerp(
                          Colors.white70,
                          Colors.white,
                          (1.0 - distance).clamp(0.0, 1.0),
                        );

                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _onTap(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutCubic,
                              transform: Matrix4.identity()
                                ..scale(isActive ? 1.05 : 1.0), // Reduced scale to fit better
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOutCubic,
                                    child: Icon(
                                      item.icon,
                                      size: screenWidth * 0.070, // Slightly reduced icon size
                                      color: iconColor?.withOpacity(opacity),
                                    ),
                                  ),
                                  const SizedBox(height: 4), // Increased spacing
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOutCubic,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 10, // Increased font size
                                      fontWeight: isActive
                                          ? FontWeight.bold
                                          : FontWeight.w400,
                                      color: iconColor?.withOpacity(opacity),
                                    ),
                                    child: Text(
                                      item.label,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}

class _EnhancedLiquidPill extends StatelessWidget {
  final double width;
  final bool isDragging;
  final double animationValue;

  const _EnhancedLiquidPill({
    required this.width,
    required this.isDragging,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          width: width,
          height: 56, // Increased from previous height to better fit the 72px navbar
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white.withOpacity(0.16),

            // 🌊 Liquid refraction simulated with a gradient
            gradient: RadialGradient(
              radius: 1.5,
              colors: [
                Colors.white.withOpacity(0.40), // highlight spot
                Colors.white.withOpacity(0.02),
              ],
              center: const Alignment(-0.6, -0.8),
            ),

            // 🍸 Thin glossy border
            border: Border.all(
              color: Colors.white.withOpacity(0.32),
              width: 1.3,
            ),

            // 💧 Subtle inner shadow at bottom
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.08),
                blurRadius: 12,
                spreadRadius: -4,
                offset: const Offset(0, -2),
              ),
            ],
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