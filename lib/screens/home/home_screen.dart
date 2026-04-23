import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/metro_provider.dart';
import '../../core/providers/crowd_provider.dart';
import '../../core/providers/ticket_provider.dart';
import '../../core/data/metro_data.dart';
import '../routes/station_search_screen.dart';
import '../routes/metro_schedule_screen.dart';
import '../tickets/ticket_scanner_screen.dart';
import '../main_nav/main_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final crowd = context.watch<CrowdProvider>();
    final metro = context.watch<MetroProvider>();
    final tickets = context.watch<TicketProvider>();
    final insights = crowd.getInsights();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E21), Color(0xFF12172E)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(context, auth)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.1, end: 0),

                  const SizedBox(height: 24),

                  // Quick Route Planner Card - NOW STATE AWARE
                  _buildQuickRoutePlanner(context, metro)
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // Smart Insights
                  _buildInsightsCard(context, insights)
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // Quick Stats
                  _buildQuickStats(context, tickets, metro)
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms),

                  const SizedBox(height: 24),

                  // Live ETA Section
                  _buildLiveETA(context, metro)
                      .animate()
                      .fadeIn(delay: 450.ms, duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // Popular Stations
                  _buildPopularStations(context, metro, crowd)
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // Crowd Alerts
                  _buildCrowdAlerts(context, crowd)
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      // QR Scanner FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TicketScannerScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppAuthProvider auth) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetIcon;
    if (hour < 12) {
      greeting = 'Good Morning';
      greetIcon = Icons.wb_sunny_rounded;
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
      greetIcon = Icons.wb_sunny_outlined;
    } else {
      greeting = 'Good Evening';
      greetIcon = Icons.nightlight_round;
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(greetIcon, color: AppColors.yellowLine, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      greeting,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textMuted,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                auth.userName.isEmpty ? 'Traveller' : auth.userName,
                style: Theme.of(context).textTheme.headlineMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        // Scan QR button in header
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TicketScannerScreen()),
            );
          },
          child: Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.qr_code_scanner_rounded,
                color: AppColors.textSecondary, size: 22),
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              (auth.userName.isEmpty ? 'T' : auth.userName[0]).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// FIX: Now dynamically observes MetroProvider to display selected stations
  /// and navigates to Routes tab on "Find Routes"
  Widget _buildQuickRoutePlanner(BuildContext context, MetroProvider metro) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E2440), Color(0xFF252B48)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.route_rounded,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'home.whereTo'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Source field — dynamically reads metro.sourceStation
          GestureDetector(
            onTap: () => _openStationSearch(context, true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: metro.sourceStation != null
                      ? AppColors.success.withValues(alpha: 0.5)
                      : AppColors.textMuted.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      metro.sourceStation?.name ?? 'From Station',
                      style: TextStyle(
                        color: metro.sourceStation != null
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                        fontSize: 14,
                        fontWeight: metro.sourceStation != null
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: AppColors.textMuted, size: 18),
                ],
              ),
            ),
          ),

          // Swap + Dots connector
          Row(
            children: [
              const SizedBox(width: 21),
              Column(
                children: List.generate(
                  3,
                  (i) => Container(
                    width: 2,
                    height: 6,
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    color: AppColors.textMuted.withValues(alpha: 0.3),
                  ),
                ),
              ),
              const Spacer(),
              if (metro.sourceStation != null || metro.destinationStation != null)
                GestureDetector(
                  onTap: () => metro.swapStations(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.swap_vert_rounded,
                        color: AppColors.primary, size: 18),
                  ),
                ),
            ],
          ),

          // Destination field — dynamically reads metro.destinationStation
          GestureDetector(
            onTap: () => _openStationSearch(context, false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: metro.destinationStation != null
                      ? AppColors.error.withValues(alpha: 0.5)
                      : AppColors.textMuted.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      metro.destinationStation?.name ?? 'To Station',
                      style: TextStyle(
                        color: metro.destinationStation != null
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                        fontSize: 14,
                        fontWeight: metro.destinationStation != null
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: AppColors.textMuted, size: 18),
                ],
              ),
            ),
          ),

          // Find Route button — navigates to Routes tab
          if (metro.sourceStation != null && metro.destinationStation != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Find routes and navigate to Routes tab
                    metro.findRoutes();
                    MainNavigation.navKey.currentState?.switchToTab(1);
                  },
                  icon: const Icon(Icons.search_rounded, size: 18),
                  label: const Text('Find Routes',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInsightsCard(
      BuildContext context, Map<String, dynamic> insights) {
    final isPeak = insights['isPeakHour'] as bool;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPeak
              ? [const Color(0xFF3D1C1C), const Color(0xFF2D1515)]
              : [const Color(0xFF1C2D1C), const Color(0xFF152D15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPeak
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPeak ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                color: isPeak ? AppColors.warning : AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  isPeak ? '🔴 Peak Hours Active' : '🟢 Off-Peak Hours',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _insightRow(Icons.access_time, 'Best Time',
              insights['bestTimeToTravel'] as String),
          const SizedBox(height: 8),
          _insightRow(Icons.info_outline, 'Alert',
              insights['avoidMessage'] as String),
          const SizedBox(height: 8),
          _insightRow(Icons.lightbulb_outline, 'Tip',
              insights['recommendation'] as String),
        ],
      ),
    );
  }

  Widget _insightRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textMuted, size: 16),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(
      BuildContext context, TicketProvider tickets, MetroProvider metro) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => MainNavigation.navKey.currentState?.switchToTab(4),
            child: _statCard(
              context,
              icon: Icons.confirmation_num_rounded,
              label: 'Total Trips',
              value: '${tickets.totalTrips}',
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => MainNavigation.navKey.currentState?.switchToTab(4),
            child: _statCard(
              context,
              icon: Icons.currency_rupee_rounded,
              label: 'Total Spent',
              value: '₹${tickets.totalSpent}',
              color: AppColors.aquaLine,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => MainNavigation.navKey.currentState?.switchToTab(2),
            child: _statCard(
              context,
              icon: Icons.train_rounded,
              label: 'Lines',
              value: '${metro.lines.length}',
              color: AppColors.yellowLine,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(BuildContext context,
      {required IconData icon,
      required String label,
      required String value,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveETA(BuildContext context, MetroProvider metro) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '⏱ Live Train ETA',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MetroScheduleScreen()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: const Text('Timetable', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Based on official Mumbai Metro frequencies',
          style: TextStyle(color: AppColors.textMuted, fontSize: 10),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: metro.lines.length,
            separatorBuilder: (_, i) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final line = metro.lines[index];
              final eta = metro.getNextTrainETA(line.id);
              final minutes = eta['minutes'] as int;

              return Container(
                width: 160,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: line.color.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: line.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            line.shortName,
                            style: TextStyle(
                              color: line.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      minutes < 0
                          ? 'Service Ended'
                          : minutes == 0
                              ? 'Arriving Now'
                              : '$minutes min',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: minutes < 0 ? 13 : 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Next: ${eta['nextTrain']}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularStations(
      BuildContext context, MetroProvider metro, CrowdProvider crowd) {
    final stations = metro.popularStations;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📍 Popular Stations',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        ...stations.map((station) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: MetroData().getLineColor(station.lineId),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          MetroData().getLine(station.lineId)?.name ?? '',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          crowd.getCrowdColor(station.id).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          crowd.getCrowdIcon(station.id),
                          color: crowd.getCrowdColor(station.id),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            crowd.getCrowdText(station.id),
                            style: TextStyle(
                              color: crowd.getCrowdColor(station.id),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildCrowdAlerts(BuildContext context, CrowdProvider crowd) {
    final crowded = crowd.mostCrowdedStations;
    if (crowded.isEmpty) return const SizedBox.shrink();

    final metroData = MetroData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚠️ Crowd Alerts',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: crowded.take(3).map((entry) {
              final station = metroData.findStationById(entry.key);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.groups_rounded,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        station?.name ?? entry.key,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'HIGH',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _openStationSearch(BuildContext context, bool isSource) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StationSearchScreen(isSource: isSource),
      ),
    );
  }
}
