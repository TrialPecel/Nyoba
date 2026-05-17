import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/gallery_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/animated_app_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/photo_grid.dart';
import '../widgets/photo_list.dart';
import '../widgets/album_grid.dart';
import '../widgets/shimmer_loading.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fabController;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    context.read<GalleryProvider>().loadPhotos();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _onScroll(ScrollNotification notification) {
    final isScrolled = notification.metrics.pixels > 50;
    if (isScrolled != _isScrolled) {
      setState(() => _isScrolled = isScrolled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final galleryProvider = context.watch<GalleryProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _onScroll(notification);
          return false;
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AnimatedAppBar(
              isScrolled: _isScrolled,
              onSearchTap: () => _openSearch(context),
              onSettingsTap: () => _openSettings(context),
              onViewModeTap: () => galleryProvider.toggleViewMode(),
              viewMode: galleryProvider.viewMode,
            ),
            SliverToBoxAdapter(
              child: CategoryChips(
                categories: galleryProvider.categories,
                selectedCategory: galleryProvider.selectedCategory,
                onCategorySelected: (category) =>
                    galleryProvider.setCategory(category),
              ),
            ),
            if (galleryProvider.isLoading)
              const SliverToBoxAdapter(child: ShimmerLoading())
            else if (galleryProvider.selectedTab == 0)
              galleryProvider.viewMode == ViewMode.grid
                  ? PhotoGrid(photos: galleryProvider.filteredPhotos)
                  : PhotoList(photos: galleryProvider.filteredPhotos)
            else
              AlbumGrid(albums: galleryProvider.albums),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(isDark),
      bottomNavigationBar: _buildBottomNav(galleryProvider, isDark),
    );
  }

  Widget _buildFloatingActionButton(bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: FloatingActionButton.extended(
        onPressed: () => _showAddOptions(context),
        backgroundColor: const Color(0xFF6366F1),
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    )
        .animate()
        .scale(delay: const Duration(milliseconds: 500))
        .fadeIn(delay: const Duration(milliseconds: 500));
  }

  Widget _buildBottomNav(GalleryProvider provider, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.photo_library_rounded, 'Photos', 0, provider),
              _buildNavItem(Icons.folder_rounded, 'Albums', 1, provider),
              _buildNavItem(Icons.favorite_rounded, 'Favorites', 2, provider),
              _buildNavItem(Icons.person_rounded, 'Profile', 3, provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, int index, GalleryProvider provider) {
    final isSelected = provider.selectedTab == index;

    return GestureDetector(
      onTap: () => provider.setSelectedTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF6366F1) : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF6366F1) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionTile(
              context,
              icon: Icons.camera_alt_rounded,
              title: 'Take Photo',
              subtitle: 'Capture a new moment',
              color: const Color(0xFF6366F1),
            ),
            _buildOptionTile(
              context,
              icon: Icons.videocam_rounded,
              title: 'Record Video',
              subtitle: 'Start recording',
              color: const Color(0xFFEC4899),
            ),
            _buildOptionTile(
              context,
              icon: Icons.photo_rounded,
              title: 'Choose from Gallery',
              subtitle: 'Select existing photos',
              color: const Color(0xFF10B981),
            ),
            _buildOptionTile(
              context,
              icon: Icons.link_rounded,
              title: 'Import from URL',
              subtitle: 'Download from the web',
              color: const Color(0xFFF59E0B),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      onTap: () => Navigator.pop(context),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }
}
