import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackBar {
  // Custom Snackbar
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    String? actionLabel,
    VoidCallback? onAction,
    Color? backgroundColor,
    Color? iconColor,
    Color? textColor,
    Duration? duration,
  }) {
    // Hide any existing SnackBar first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Detect system brightness (light/dark)
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Dynamic colors
    final Color bgColor =
        backgroundColor ??
        (isDarkMode ? const Color(0xFF1E1E1E) : Colors.white);
    final Color iconBgColor = isDarkMode
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.05);
    final Color iconClr =
        iconColor ?? (isDarkMode ? Colors.white : Colors.black);
    final Color txtColor =
        textColor ?? (isDarkMode ? Colors.white : Colors.black87);

    // Get screen width for responsive sizing
    final double screenWidth = MediaQuery.of(context).size.width;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // 5% padding from sides
          vertical: 10,
        ),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1),
                blurRadius: isDarkMode ? 15 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon wrapper
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconClr, size: 24),
              ),
              const SizedBox(width: 12),
              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: txtColor,
                      ),
                    ),
                    if (message.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      // Message
                      Text(
                        message,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: txtColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                    // Action Button
                    if (actionLabel != null && onAction != null)
                      TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(top: 8),
                        ),
                        child: Text(
                          actionLabel,
                          style: GoogleFonts.montserrat(
                            color: isDarkMode
                                ? Colors.redAccent.shade200
                                : Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }

  // NEW: Overlay-based notification that shows above modals
  static OverlayEntry? _currentOverlay;

  static void showOverlayNotification(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    Color? backgroundColor,
    Color? iconColor,
    Color? textColor,
    Duration? duration,
  }) {
    // Remove any existing overlay
    _currentOverlay?.remove();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic colors
    final Color bgColor =
        backgroundColor ??
        (isDarkMode ? const Color(0xFF1E1E1E) : Colors.white);
    final Color iconBgColor = isDarkMode
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.05);
    final Color iconClr =
        iconColor ?? (isDarkMode ? Colors.white : Colors.black);
    final Color txtColor =
        textColor ?? (isDarkMode ? Colors.white : Colors.black87);

    _currentOverlay = OverlayEntry(
      builder: (context) => _OverlayNotification(
        title: title,
        message: message,
        icon: icon,
        backgroundColor: bgColor,
        iconBackgroundColor: iconBgColor,
        iconColor: iconClr,
        textColor: txtColor,
        screenWidth: screenWidth,
        onDismiss: () {
          _currentOverlay?.remove();
          _currentOverlay = null;
        },
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);

    // Auto dismiss after duration
    Future.delayed(duration ?? const Duration(seconds: 4), () {
      _currentOverlay?.remove();
      _currentOverlay = null;
    });
  }

  // Success Snackbar (with overlay option)
  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool useOverlay = false, // NEW: Option to use overlay
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (useOverlay) {
      showOverlayNotification(
        context,
        title: title,
        message: message,
        icon: Icons.check_circle_outline,
        backgroundColor: isDarkMode
            ? const Color(0xFF0A3320)
            : Colors.green.shade50,
        iconColor: isDarkMode ? const Color(0xFF4CAF50) : Colors.green,
        textColor: isDarkMode ? Colors.white : null,
      );
    } else {
      show(
        context,
        title: title,
        message: message,
        icon: Icons.check_circle_outline,
        actionLabel: actionLabel,
        onAction: onAction,
        backgroundColor: isDarkMode
            ? const Color(0xFF0A3320)
            : Colors.green.shade50,
        iconColor: isDarkMode ? const Color(0xFF4CAF50) : Colors.green,
        textColor: isDarkMode ? Colors.white : null,
      );
    }
  }

  // Error Snackbar (with overlay option)
  static void showError(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool useOverlay = false, // NEW: Option to use overlay
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (useOverlay) {
      showOverlayNotification(
        context,
        title: title,
        message: message,
        icon: Icons.error_outline,
        backgroundColor: isDarkMode
            ? const Color(0xFF331111)
            : Colors.red.shade50,
        iconColor: isDarkMode ? const Color(0xFFFF5252) : Colors.red,
        textColor: isDarkMode ? Colors.white : null,
      );
    } else {
      show(
        context,
        title: title,
        message: message,
        icon: Icons.error_outline,
        actionLabel: actionLabel,
        onAction: onAction,
        backgroundColor: isDarkMode
            ? const Color(0xFF331111)
            : Colors.red.shade50,
        iconColor: isDarkMode ? const Color(0xFFFF5252) : Colors.red,
        textColor: isDarkMode ? Colors.white : null,
      );
    }
  }

  // Warning Snackbar (with overlay option)
  static void showWarning(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool useOverlay = false, // NEW: Option to use overlay
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (useOverlay) {
      showOverlayNotification(
        context,
        title: title,
        message: message,
        icon: Icons.warning_amber_outlined,
        backgroundColor: isDarkMode
            ? const Color(0xFF332711)
            : Colors.orange.shade50,
        iconColor: isDarkMode ? const Color(0xFFFFB74D) : Colors.orange,
        textColor: isDarkMode ? Colors.white : null,
      );
    } else {
      show(
        context,
        title: title,
        message: message,
        icon: Icons.warning_amber_outlined,
        actionLabel: actionLabel,
        onAction: onAction,
        backgroundColor: isDarkMode
            ? const Color(0xFF332711)
            : Colors.orange.shade50,
        iconColor: isDarkMode ? const Color(0xFFFFB74D) : Colors.orange,
        textColor: isDarkMode ? Colors.white : null,
      );
    }
  }

  // Info Snackbar (with overlay option)
  static void showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool useOverlay = false, // NEW: Option to use overlay
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (useOverlay) {
      showOverlayNotification(
        context,
        title: title,
        message: message,
        icon: Icons.info_outline,
        backgroundColor: isDarkMode
            ? const Color(0xFF0A1B33)
            : Colors.blue.shade50,
        iconColor: isDarkMode ? const Color(0xFF64B5F6) : Colors.blue,
        textColor: isDarkMode ? Colors.white : null,
      );
    } else {
      show(
        context,
        title: title,
        message: message,
        icon: Icons.info_outline,
        actionLabel: actionLabel,
        onAction: onAction,
        backgroundColor: isDarkMode
            ? const Color(0xFF0A1B33)
            : Colors.blue.shade50,
        iconColor: isDarkMode ? const Color(0xFF64B5F6) : Colors.blue,
        textColor: isDarkMode ? Colors.white : null,
      );
    }
  }
}

// Widget for overlay notification
class _OverlayNotification extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color textColor;
  final double screenWidth;
  final VoidCallback onDismiss;

  const _OverlayNotification({
    required this.title,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.screenWidth,
    required this.onDismiss,
  });

  @override
  State<_OverlayNotification> createState() => _OverlayNotificationState();
}

class _OverlayNotificationState extends State<_OverlayNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: widget.screenWidth * 0.05,
      right: widget.screenWidth * 0.05,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () async {
                await _controller.reverse();
                widget.onDismiss();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon wrapper
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.iconBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.iconColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Texts
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title
                          Text(
                            widget.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: widget.textColor,
                            ),
                          ),
                          if (widget.message.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            // Message
                            Text(
                              widget.message,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: widget.textColor.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Dismiss button
                    GestureDetector(
                      onTap: () async {
                        await _controller.reverse();
                        widget.onDismiss();
                      },
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: widget.textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
