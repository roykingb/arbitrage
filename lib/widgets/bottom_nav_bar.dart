import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: AppTheme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              context,
              icon: Icons.map,
              label: 'Map',
              index: 0,
              route: '/map',
            ),
            _buildNavItem(
              context,
              icon: Icons.explore,
              label: 'Discover',
              index: 1,
              route: '/discover',
            ),
            _buildNavItem(
              context,
              icon: Icons.chat_bubble,
              label: 'Chat',
              index: 2,
              route: '/chat',
            ),
            _buildNavItem(
              context,
              icon: Icons.person,
              label: 'Profile',
              index: 3,
              route: '/profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required String route,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppTheme.primary : const Color(0xFF64748B); // slate-500

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          if (route == '/map' || route == '/profile') {
            Navigator.pushReplacementNamed(context, route);
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
