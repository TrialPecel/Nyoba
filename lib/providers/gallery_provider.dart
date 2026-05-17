import 'dart:math';
import 'package:flutter/material.dart';
import '../models/photo_model.dart';

class GalleryProvider extends ChangeNotifier {
  List<PhotoModel> _photos = [];
  List<PhotoModel> _favorites = [];
  List<AlbumModel> _albums = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  int _selectedTab = 0;
  ViewMode _viewMode = ViewMode.grid;

  List<PhotoModel> get photos => _photos;
  List<PhotoModel> get favorites => _favorites;
  List<AlbumModel> get albums => _albums;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  int get selectedTab => _selectedTab;
  ViewMode get viewMode => _viewMode;

  List<String> get categories => [
    'All',
    'Photos',
    'Videos',
    'Favorites',
    'Selfies',
    'Screenshots',
  ];

  List<PhotoModel> get filteredPhotos {
    if (_selectedCategory == 'All') return _photos;
    if (_selectedCategory == 'Favorites') return _favorites;
    return _photos.where((p) {
      if (_selectedCategory == 'Photos') return p.tags.contains('photo');
      if (_selectedCategory == 'Videos') return p.tags.contains('video');
      if (_selectedCategory == 'Selfies') return p.tags.contains('selfie');
      if (_selectedCategory == 'Screenshots') return p.tags.contains('screenshot');
      return true;
    }).toList();
  }

  void setSelectedTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleViewMode() {
    _viewMode = _viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid;
    notifyListeners();
  }

  void toggleFavorite(String photoId) {
    final index = _photos.indexWhere((p) => p.id == photoId);
    if (index != -1) {
      final photo = _photos[index];
      final updated = photo.copyWith(isFavorite: !photo.isFavorite);
      _photos[index] = updated;

      if (updated.isFavorite) {
        _favorites.add(updated);
      } else {
        _favorites.removeWhere((p) => p.id == photoId);
      }
      notifyListeners();
    }
  }

  Future<void> loadPhotos() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _photos = _generateMockPhotos();
    _favorites = _photos.where((p) => p.isFavorite).toList();
    _albums = _generateMockAlbums();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshPhotos() async {
    await Future.delayed(const Duration(seconds: 1));
    _photos = _generateMockPhotos();
    _favorites = _photos.where((p) => p.isFavorite).toList();
    notifyListeners();
  }

  List<PhotoModel> _generateMockPhotos() {
    final random = Random();
    final titles = [
      'Mountain Sunrise', 'Ocean Waves', 'City Lights', 'Forest Path',
      'Desert Dunes', 'Snowy Peak', 'Autumn Leaves', 'Spring Flowers',
      'Urban Architecture', 'Sunset Beach', 'Starry Night', 'Morning Mist',
      'Crystal Lake', 'Golden Hour', 'Rainy Day', 'Cherry Blossom',
      'Northern Lights', 'Tropical Paradise', 'Ancient Ruins', 'Modern Art',
    ];

    final locations = [
      'Bali, Indonesia', 'Tokyo, Japan', 'Paris, France', 'New York, USA',
      'Sydney, Australia', 'London, UK', 'Dubai, UAE', 'Singapore',
      'Seoul, South Korea', 'Bangkok, Thailand',
    ];

    final tags = ['photo', 'video', 'selfie', 'screenshot'];

    return List.generate(30, (index) {
      final width = 800 + random.nextInt(400);
      final height = 600 + random.nextInt(600);
      final isPortrait = random.nextBool();
      final finalWidth = isPortrait ? min(width, height) : max(width, height);
      final finalHeight = isPortrait ? max(width, height) : min(width, height);

      return PhotoModel(
        id: 'photo_$index',
        url: 'https://picsum.photos/seed/${index + 100}/$finalWidth/$finalHeight',
        thumbnailUrl: 'https://picsum.photos/seed/${index + 100}/400/${(400 * finalHeight / finalWidth).round()}',
        title: titles[index % titles.length],
        description: 'A beautiful capture of ${titles[index % titles.length].toLowerCase()}',
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(365))),
        width: finalWidth,
        height: finalHeight,
        isFavorite: random.nextDouble() < 0.2,
        location: locations[index % locations.length],
        tags: [tags[random.nextInt(tags.length)]],
      );
    });
  }

  List<AlbumModel> _generateMockAlbums() {
    final albumNames = [
      'Camera', 'Favorites', 'Screenshots', 'Selfies',
      'Instagram', 'WhatsApp', 'Downloads', 'Travel',
    ];

    return List.generate(albumNames.length, (index) {
      return AlbumModel(
        id: 'album_$index',
        name: albumNames[index],
        coverUrl: 'https://picsum.photos/seed/album${index + 200}/400/400',
        photoCount: 10 + Random().nextInt(200),
        createdAt: DateTime.now().subtract(Duration(days: Random().nextInt(365))),
      );
    });
  }
}

enum ViewMode { grid, list }
