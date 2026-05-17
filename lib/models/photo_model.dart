class PhotoModel {
  final String id;
  final String url;
  final String thumbnailUrl;
  final String title;
  final String? description;
  final DateTime createdAt;
  final int width;
  final int height;
  final bool isFavorite;
  final String? location;
  final List<String> tags;

  PhotoModel({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
    required this.title,
    this.description,
    required this.createdAt,
    required this.width,
    required this.height,
    this.isFavorite = false,
    this.location,
    this.tags = const [],
  });

  PhotoModel copyWith({
    String? id,
    String? url,
    String? thumbnailUrl,
    String? title,
    String? description,
    DateTime? createdAt,
    int? width,
    int? height,
    bool? isFavorite,
    String? location,
    List<String>? tags,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      width: width ?? this.width,
      height: height ?? this.height,
      isFavorite: isFavorite ?? this.isFavorite,
      location: location ?? this.location,
      tags: tags ?? this.tags,
    );
  }

  double get aspectRatio => width / height;

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes == 0) return 'Just now';
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()}w ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

class AlbumModel {
  final String id;
  final String name;
  final String? coverUrl;
  final int photoCount;
  final DateTime createdAt;

  AlbumModel({
    required this.id,
    required this.name,
    this.coverUrl,
    required this.photoCount,
    required this.createdAt,
  });
}
