import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lovestory/theme/app_theme.dart';
import 'package:lovestory/widgets/love_overlay.dart';
import 'package:lovestory/widgets/music_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Specific assets
  final String startImage = "assets/images/1770272714265(1).png";
  final String proposalImage = "assets/images/20251031_224904.jpg";

  // Gallery
  List<String> _galleryImages = [];

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages() async {
    final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    
    final allImages = manifestMap.keys
        .where((String key) => key.contains('assets/images/'))
        .where((String key) => !key.contains('.DS_Store')) // mac junk safety
        .toList();

    // Filter out special ones to avoid duplication if desired, or keep them.
    // Let's filter them out from the "Gallery" section so they are special.
    // Note: AssetManifest paths might be slightly different (e.g. encoded), but usually match.
    // We'll normalize or just simple string check.
    
    setState(() {
      _galleryImages = allImages.where((path) {
        return path != startImage && path != proposalImage;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoveOverlayManager(
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: Stack(
          children: [
            // Background decoration (subtle hearts or gradient)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.background,
                      Colors.white,
                      AppTheme.softPink.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
            
            // Main Content
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildStoryCard(
                          context,
                          title: "Начало нашей истории",
                          date: DateTime(2024, 12, 27),
                          imagePath: startImage,
                          description: "Все началось именно в этот день...",
                          delay: 200,
                        ),
                        const SizedBox(height: 40),
                        _buildStoryCard(
                          context,
                          title: "Я сделал предложение",
                          date: DateTime(2025, 10, 29),
                          imagePath: proposalImage,
                          description: "Самый важный вопрос и самое долгожданное 'Да'!",
                          delay: 400,
                          isSpecial: true,
                        ),
                        const SizedBox(height: 40),
                         Text(
                          "Наши моменты",
                          style: GoogleFonts.greatVibes(
                            fontSize: 40,
                            color: AppTheme.darkRed,
                          ),
                        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                _buildGallerySliver(),
                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            ),

            // Floating Music Player
            const Positioned(
              bottom: 20,
              right: 20,
              child: MusicPlayerWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "Love Story",
          style: GoogleFonts.greatVibes(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              startImage, // Use start image as header bg too? Or maybe just a color/pattern. 
                          // Let's use the start image with blur.
              fit: BoxFit.cover,
            ),
            Container(color: Colors.black38), // Dim
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   const SizedBox(height: 40),
                   Text(
                    "Надежда & Арсений",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ).animate().fadeIn(duration: 1000.ms).slideY(begin: -0.5, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard(
    BuildContext context, {
    required String title,
    required DateTime date,
    required String imagePath,
    required String description,
    required int delay,
    bool isSpecial = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              imagePath,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSpecial)
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text("SPECIAL MOMENT", style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.5)),
                    ],
                  ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.yMMMMd('ru').format(date), // Requires intl initialization
                  style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: delay))
     .fadeIn(duration: 600.ms)
     .slideY(begin: 0.1, end: 0);
  }

  Widget _buildGallerySliver() {
    if (_galleryImages.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final path = _galleryImages[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                     color: Colors.black.withOpacity(0.1),
                     blurRadius: 5,
                     offset: const Offset(0, 2),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  path,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => const Center(child: Icon(Icons.error)),
                ),
              ),
            ).animate(delay: (100 * index).ms)
             .fadeIn(duration: 500.ms)
             .scale(begin: const Offset(0.9, 0.9));
          },
          childCount: _galleryImages.length,
        ),
      ),
    );
  }
}
