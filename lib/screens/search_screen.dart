import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/photo_model.dart';
import '../providers/gallery_provider.dart';
import '../widgets/photo_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final galleryProvider = context.watch<GalleryProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<PhotoModel> searchResults = _query.isEmpty
        ? []
        : galleryProvider.photos
            .where((p) =>
                p.title.toLowerCase().contains(_query.toLowerCase()) ||
                (p.location?.toLowerCase().contains(_query.toLowerCase()) ?? false))
            .toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search photos...',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                          ),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _query = '');
                                  },
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onChanged: (value) => setState(() => _query = value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_query.isEmpty) ...[
              _buildRecentSearches(isDark),
              _buildSuggestions(isDark),
            ] else if (searchResults.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: isDark ? Colors.grey[700] : Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: PhotoGrid(photos: searchResults),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches(bool isDark) {
    final recentSearches = ['Mountain', 'Beach', 'Sunset', 'City'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recentSearches.map((search) {
              return ActionChip(
                avatar: Icon(
                  Icons.history_rounded,
                  size: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                label: Text(search),
                backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                side: BorderSide.none,
                onPressed: () {
                  _searchController.text = search;
                  setState(() => _query = search);
                },
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildSuggestions(bool isDark) {
    final suggestions = [
      ('Nature', Icons.forest_rounded, const Color(0xFF10B981)),
      ('People', Icons.people_rounded, const Color(0xFF6366F1)),
      ('Architecture', Icons.architecture_rounded, const Color(0xFFF59E0B)),
      ('Food', Icons.restaurant_rounded, const Color(0xFFEC4899)),
      ('Travel', Icons.flight_takeoff_rounded, const Color(0xFF3B82F6)),
      ('Animals', Icons.pets_rounded, const Color(0xFF8B5CF6)),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final (name, icon, color) = suggestions[index];
              return Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: Duration(milliseconds: index * 50))
                  .fadeIn()
                  .slideX(begin: -0.1, end: 0);
            },
          ),
        ],
      ),
    );
  }
}
