import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/gallery_provider.dart';

class AnimatedAppBar extends StatelessWidget {
  final bool isScrolled;
  final VoidCallback onSearchTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onViewModeTap;
  final ViewMode viewMode;

  const AnimatedAppBar({
    super.key,
    required this.isScrolled,
    required this.onSearchTap,
    required this.onSettingsTap,
    required this.onViewModeTap,
    required this.viewMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      elevation: isScrolled ? 4 : 0,
      backgroundColor: isScrolled
          ? (isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FA))
              .withOpacity(0.95)
          : Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isScrolled ? 1.0 : 0.0,
          child: Text(
            'Gallery',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.bottomLeft,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Gallery',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                              letterSpacing: -0.5,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: const Duration(milliseconds: 600))
                              .slideY(begin: 0.3, end: 0),
                          const SizedBox(height: 4),
                          Text(
                            '1,234 photos · 56 videos',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          )
                              .animate(delay: const Duration(milliseconds: 200))
                              .fadeIn(duration: const Duration(milliseconds: 600))
                              .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    ),
                    _buildIconButton(
                      icon: viewMode == ViewMode.grid
                          ? Icons.grid_view_rounded
                          : Icons.view_list_rounded,
                      onTap: onViewModeTap,
                      isDark: isDark,
                    )
                        .animate(delay: const Duration(milliseconds: 300))
                        .fadeIn()
                        .scale(),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      icon: Icons.search_rounded,
                      onTap: onSearchTap,
                      isDark: isDark,
                    )
                        .animate(delay: const Duration(milliseconds: 400))
                        .fadeIn()
                        .scale(),
                    const SizedBox(width: 8),
                    _buildIconButton(
                      icon: Icons.settings_rounded,
                      onTap: onSettingsTap,
                      isDark: isDark,
                    )
                        .animate(delay: const Duration(milliseconds: 500))
                        .fadeIn()
                        .scale(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 22,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }
}
