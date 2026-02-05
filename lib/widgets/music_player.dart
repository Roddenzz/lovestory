import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lovestory/theme/app_theme.dart';

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({super.key});

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _initAudio();
  }

  Future<void> _initAudio() async {
    // Set to loop
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    // Load the audio but don't play automatically unless user taps (or auto-play if desired, but modern mobile policies often block autoplay)
    // We will auto-play for effect, but handle errors.
    try {
      await _audioPlayer.setSource(AssetSource('audio/music.mp3'));
      // Don't auto play strictly to avoid annoyance, let user click start or have a start button on splash.
      // But user said "Add music as a cool player", imply availability.
      // Let's auto play at low volume potentially? No, explicit is better.
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
        if (_isPlaying) {
          _animationController.repeat();
        } else {
          _animationController.stop();
        }
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: AppTheme.primaryColor,
              size: 40,
            ),
            onPressed: _togglePlay,
          ),
          const SizedBox(width: 8),
          Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const Text(
                 "Our Melody",
                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
               ),
               SizedBox(
                 height: 10,
                 width: 80,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: List.generate(5, (index) {
                     return _MusicBar(
                       animation: _animationController, 
                       delay: index * 0.1,
                       isPlaying: _isPlaying
                     );
                   }),
                 ),
               ),
             ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 1, end: 0);
  }
}

class _MusicBar extends StatelessWidget {
  final AnimationController animation;
  final double delay;
  final bool isPlaying;

  const _MusicBar({
    required this.animation,
    required this.delay,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        double height = 4;
        if (isPlaying) {
          final double t = (animation.value + delay) % 1.0;
           height = 4 + (10 * (0.5 - (0.5 - t).abs())); // simple wave
        }
        return Container(
          width: 4,
          height: height,
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }
}
