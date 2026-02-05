import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lovestory/theme/app_theme.dart';

class LoveOverlayManager extends StatefulWidget {
  final Widget child;
  const LoveOverlayManager({super.key, required this.child});

  @override
  State<LoveOverlayManager> createState() => _LoveOverlayManagerState();
}

class _LoveOverlayManagerState extends State<LoveOverlayManager> {
  Timer? _timer;
  bool _showPopup = false;

  @override
  void initState() {
    super.initState();
    // Every 15 seconds show the popup
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted) {
        _triggerPopup();
      }
    });
  }

  void _triggerPopup() {
    setState(() {
      _showPopup = true;
    });
    
    // Hide after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showPopup = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showPopup)
          Positioned(
            top: 100, // Slightly safer than top 0
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.darkRed.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      "Я тебя люблю, котенок",
                      style: GoogleFonts.caveat(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.favorite, color: Colors.white),
                  ],
                ),
              )
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut)
              .shake(delay: 500.ms)
              .then(delay: 2500.ms) // wait visible
              .fadeOut(duration: 500.ms),
            ),
          ),
      ],
    );
  }
}
