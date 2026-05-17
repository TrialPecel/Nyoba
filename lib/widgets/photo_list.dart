import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/photo_model.dart';
import '../screens/photo_detail_screen.dart';

class PhotoList extends StatelessWidget {
  final List<PhotoModel> photos;

  const PhotoList({
    super.key,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];

          return GestureDetector(
            onTap: () => _openPhotoDetail(context, index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
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
                child: Row(
                  children: [
                    Hero(
                      tag: 'photo_${photo.id}',
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(photo.thumbnailUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              photo.title,
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
                              photo.description ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    photo.location ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  photo.formattedDate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                                  ),
                                ),
                              ],
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
              .animate(delay: Duration(milliseconds: index * 40))
              .fadeIn(duration: const Duration(milliseconds: 500))
              .slideX(begin: 0.2, end: 0, duration: const Duration(milliseconds: 500));
        },
      ),
    );
  }

  void _openPhotoDetail(BuildContext context, int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PhotoDetailScreen(
          photos: photos,
          initialIndex: index,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
