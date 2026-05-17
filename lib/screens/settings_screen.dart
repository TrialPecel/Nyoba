import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6366F1).withOpacity(0.2),
                      const Color(0xFF8B5CF6).withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Appearance', isDark),
                  const SizedBox(height: 12),
                  _buildThemeCard(themeProvider, isDark),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Storage', isDark),
                  const SizedBox(height: 12),
                  _buildStorageCard(isDark),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Preferences', isDark),
                  const SizedBox(height: 12),
                  _buildPreferenceTile(
                    icon: Icons.notifications_rounded,
                    title: 'Notifications',
                    subtitle: 'Get notified about new photos',
                    color: const Color(0xFF3B82F6),
                    isDark: isDark,
                    trailing: Switch(
                      value: true,
                      onChanged: (_) {},
                      activeColor: const Color(0xFF6366F1),
                    ),
                  ),
                  _buildPreferenceTile(
                    icon: Icons.backup_rounded,
                    title: 'Auto Backup',
                    subtitle: 'Backup photos to cloud',
                    color: const Color(0xFF10B981),
                    isDark: isDark,
                    trailing: Switch(
                      value: false,
                      onChanged: (_) {},
                      activeColor: const Color(0xFF6366F1),
                    ),
                  ),
                  _buildPreferenceTile(
                    icon: Icons.wifi_lock_rounded,
                    title: 'Wi-Fi Only',
                    subtitle: 'Only sync on Wi-Fi',
                    color: const Color(0xFFF59E0B),
                    isDark: isDark,
                    trailing: Switch(
                      value: true,
                      onChanged: (_) {},
                      activeColor: const Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('About', isDark),
                  const SizedBox(height: 12),
                  _buildPreferenceTile(
                    icon: Icons.info_rounded,
                    title: 'Version',
                    subtitle: '1.0.0',
                    color: const Color(0xFF6366F1),
                    isDark: isDark,
                  ),
                  _buildPreferenceTile(
                    icon: Icons.privacy_tip_rounded,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    color: const Color(0xFFEC4899),
                    isDark: isDark,
                  ),
                  _buildPreferenceTile(
                    icon: Icons.help_rounded,
                    title: 'Help & Support',
                    subtitle: 'Get help with the app',
                    color: const Color(0xFF8B5CF6),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildThemeCard(ThemeProvider themeProvider, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.palette_rounded,
                  color: Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Switch between light and dark themes',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDark,
                onChanged: (_) => themeProvider.toggleTheme(),
                activeColor: const Color(0xFF6366F1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildThemeOption(
                  'System',
                  Icons.settings_suggest_rounded,
                  themeProvider.themeMode == ThemeMode.system,
                  () => themeProvider.setThemeMode(ThemeMode.system),
                  isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildThemeOption(
                  'Light',
                  Icons.wb_sunny_rounded,
                  themeProvider.themeMode == ThemeMode.light,
                  () => themeProvider.setThemeMode(ThemeMode.light),
                  isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildThemeOption(
                  'Dark',
                  Icons.nights_stay_rounded,
                  themeProvider.themeMode == ThemeMode.dark,
                  () => themeProvider.setThemeMode(ThemeMode.dark),
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withOpacity(0.1)
              : isDark
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6366F1)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : isDark
                      ? Colors.grey[500]
                      : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : isDark
                        ? Colors.grey[400]
                        : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageCard(bool isDark) {
    const totalStorage = 64.0;
    const usedStorage = 42.5;
    const usedPercentage = usedStorage / totalStorage;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.storage_rounded,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Storage',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$usedStorage GB of $totalStorage GB used',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: usedPercentage,
              backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0),
              valueColor: AlwaysStoppedAnimation(
                usedPercentage > 0.8
                    ? const Color(0xFFEF4444)
                    : usedPercentage > 0.6
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF10B981),
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStorageStat('Photos', '1,234', const Color(0xFF6366F1)),
              _buildStorageStat('Videos', '56', const Color(0xFFEC4899)),
              _buildStorageStat('Albums', '12', const Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
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
        trailing: trailing,
        onTap: trailing == null ? () {} : null,
      ),
    );
  }
}
