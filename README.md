# Gallery App

A modern Flutter Gallery application with beautiful animations and smooth UI.

## Features

### UI Components
- **Splash Screen** - Animated splash with scale and fade effects
- **Home Screen** - Custom scrollable app bar with parallax effect
- **Photo Grid** - Masonry layout with staggered heights
- **Photo List** - List view with hero animations
- **Album Grid** - 2-column grid for albums
- **Photo Detail** - Full-screen viewer with zoom, pan, and swipe
- **Search Screen** - Real-time search with categories
- **Settings Screen** - Theme switcher, storage info, preferences

### Animations
- **Splash Animation** - Scale + fade with staggered text
- **Hero Animation** - Smooth photo transitions
- **Scroll Animations** - App bar transformation on scroll
- **Staggered Animations** - Grid items animate in sequence
- **Bottom Sheet** - Slide up with gesture support
- **Page Transitions** - Custom fade and slide transitions
- **Category Chips** - Gradient selection with shadow glow
- **Shimmer Loading** - Skeleton loading effect

### Features
- Dark/Light/System theme support
- Category filtering (All, Photos, Videos, Favorites, etc.)
- Grid/List view toggle
- Favorite photos
- Photo zoom and pan
- Swipe between photos
- Search with recent searches
- Storage usage visualization
- Bottom navigation (Photos, Albums, Favorites, Profile)
- Floating action button with options

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  flutter_staggered_grid_view: ^0.7.0
  photo_view: ^0.14.0
  flutter_animate: ^4.3.0
  shimmer: ^3.0.0
  provider: ^6.1.1
  intl: ^0.18.1
```

## Installation

1. Make sure you have Flutter installed (>=3.0.0)
2. Clone or download this project
3. Run:

```bash
cd gallery_app
flutter pub get
flutter run
```

## Project Structure

```
gallery_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── photo_model.dart
│   ├── providers/
│   │   ├── gallery_provider.dart
│   │   └── theme_provider.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── home_screen.dart
│   │   ├── photo_detail_screen.dart
│   │   ├── search_screen.dart
│   │   └── settings_screen.dart
│   └── widgets/
│       ├── animated_app_bar.dart
│       ├── category_chips.dart
│       ├── photo_grid.dart
│       ├── photo_list.dart
│       ├── album_grid.dart
│       └── shimmer_loading.dart
├── pubspec.yaml
└── analysis_options.yaml
```

## Screenshots

The app features:
- Beautiful gradient accent colors (Indigo to Purple)
- Modern card-based design
- Smooth 60fps animations
- Responsive layout for all screen sizes

## License

MIT License
