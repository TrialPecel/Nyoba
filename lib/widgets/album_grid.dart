import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/photo_model.dart';

class AlbumGrid extends StatelessWidget {
  final List<AlbumModel> albums;

  const AlbumGrid({
    super.key,
    required this.albums,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];

          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          image: album.coverUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(album.coverUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          gradient: album.coverUrl == null
                              ? LinearGradient(
                                  colors: [
                                    const Color(0xFF6366F1).withOpacity(0.8),
                                    const Color(0xFF8B5CF6).withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                        ),
                        child: album.coverUrl == null
                            ? Center(
                                child: Icon(
                                  Icons.folder_rounded,
                                  size: 48,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              )
                            : null,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              album.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${album.photoCount} items',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate(delay: Duration(milliseconds: index * 60))
              .fadeIn(duration: const Duration(milliseconds: 600))
              .slideY(begin: 0.3, end: 0, duration: const Duration(milliseconds: 600))
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.0, 1.0),
                duration: const Duration(milliseconds: 600),
              );
        },
      ),
    );
  }
}
