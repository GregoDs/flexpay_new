import 'package:flutter/material.dart';

class ConnectivityBanner extends StatefulWidget {
  final bool connected;
  final String message;
  final Color backgroundColor;

  const ConnectivityBanner({
    Key? key,
    required this.connected,
    required this.message,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _offsetAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _offsetAnim = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    if (!widget.connected) {
      _ctrl.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ConnectivityBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.connected) {
      _ctrl.forward();
    } else {
      // show connected briefly then hide
      _ctrl.forward();
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) _ctrl.reverse();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return SlideTransition(
      position: _offsetAnim,
      child: Material(
        elevation: 6,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: topPadding, bottom: 12, left: 16, right: 16),
          color: widget.backgroundColor,
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Icon(widget.connected ? Icons.wifi : Icons.wifi_off, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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