import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import '../routes/routes_screen.dart';
import '../map/map_screen.dart';
import '../tickets/tickets_screen.dart';
import '../profile/profile_screen.dart';
import '../timetable/timetable_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  /// Static key to access MainNavigation state for tab switching
  static final GlobalKey<MainNavigationState> navKey =
      GlobalKey<MainNavigationState>();

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    RoutesScreen(),
    MapScreen(),
    TimetableScreen(),
    TicketsScreen(),
    ProfileScreen(),
  ];

  /// Programmatically switch to a tab (used by HomeScreen to navigate to Routes)
  void switchToTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.textMuted.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'nav.home'.tr())),
                Expanded(child: _buildNavItem(1, Icons.route_rounded, Icons.route_outlined, 'nav.routes'.tr())),
                Expanded(child: _buildNavItem(2, Icons.map_rounded, Icons.map_outlined, 'nav.map'.tr())),
                Expanded(child: _buildNavItem(3, Icons.schedule_rounded, Icons.schedule_outlined, 'Timetable')),
                Expanded(child: _buildNavItem(4, Icons.confirmation_num_rounded,
                    Icons.confirmation_num_outlined, 'nav.tickets'.tr())),
                Expanded(child: _buildNavItem(
                    5, Icons.person_rounded, Icons.person_outlined, 'nav.profile'.tr())),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
