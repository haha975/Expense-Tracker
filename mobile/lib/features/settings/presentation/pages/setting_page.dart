import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/setting_cubit.dart';
import '../bloc/setting_state.dart';

import '../../../categories/presentation/pages/categories_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Headers
                    const Text(
                      'EXPENSE TRACKER',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bloc Consumer to manage settings state reactivity
                    BlocBuilder<SettingCubit, SettingState>(
                      builder: (context, state) {
                        if (state is SettingLoading || state is SettingInitial) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
                            ),
                          );
                        }
                        if (state is SettingError) {
                          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                        }
                        if (state is SettingLoaded) {
                          final settings = state.settings;
                          return Column(
                            children: [
                              // 1. Profile Card
                              _buildProfileCard(
  name: settings.userName,
  email: settings.userEmail,
  onTap: () {},
),
                              const SizedBox(height: 16),

                              // 2. Cloud Sync Card Status
                              _buildSyncCard(context, settings),
                              const SizedBox(height: 24),

                              // 3. Preferences Section Title
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Preferences',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 4. Preferences Container Box
                              _buildPreferencesBox(context, settings),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 32),

                    // Version Footer
                    const Center(
                      child: Text(
                        'Expense Tracker · Version 1.0.0',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      
    );
  }

Widget _buildProfileCard({
  required String name,
  required String email,
  required VoidCallback onTap,
}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF18181C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF27272A), width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF4C1D95),
            child: Text(
              name.split(' ').map((e) => e[0]).join(''),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildSyncCard(BuildContext context, dynamic settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF18181C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF27272A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_done_outlined, color: Color(0xFF10B981), size: 22),
              const SizedBox(width: 10),
              const Text(
                'Everything is up to date',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 32),
            child: Text(
              'Online · All changes synced',
              style: TextStyle(color: Color(0xFF10B981), fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Last successful sync', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)),
              Text(settings.lastSyncTime, style: const TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFF27272A), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Auto-sync', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  const Text('Resumes when internet is available', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
                ],
              ),
              Switch.adaptive(
                value: settings.autoSync,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF8B5CF6),
                onChanged: (val) {
                  context.read<SettingCubit>().toggleAutoSync(val);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${settings.pendingChanges} changes pending', style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)),
              GestureDetector(
                onTap: () => context.read<SettingCubit>().triggerSync(),
                child: const Text(
                  'Sync now',
                  style: TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesBox(BuildContext context, dynamic settings) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF18181C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF27272A), width: 1),
      ),
      child: Column(
        children: [
          _buildPreferenceTile(
  iconData: Icons.currency_exchange,
  title: 'Currency',
  trailingText: settings.currency,
  showArrow: true,
  onTap: () {},
),
          _buildDivider(),
          _buildPreferenceTile(
            iconData: Icons.dark_mode_outlined,
            title: 'Appearance',
            trailingText: settings.appearance,
            showArrow: true,
            onTap: () {},
          ),
          _buildDivider(),
          _buildPreferenceTile(
  iconData: Icons.grid_view_rounded,
  title: 'Categories',
  trailingText: '${settings.categoriesCount} categories',
  showArrow: true,
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CategoriesPage(),
      ),
    );
  },
),
          _buildDivider(),
          _buildPreferenceSwitchTile(
            iconData: Icons.notifications_outlined,
            title: 'Budget reminders',
            value: settings.budgetReminders,
            onChanged: (val) {
              context.read<SettingCubit>().toggleBudgetReminders(val);
            },
          ),
          _buildDivider(),
          _buildPreferenceSwitchTile(
            iconData: Icons.face_retouching_natural,
            title: 'Face ID lock',
            value: settings.faceIdLock,
            onChanged: (val) {
              context.read<SettingCubit>().toggleFaceIdLock(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceTile({
    required IconData iconData,
    required String title,
    required String trailingText,
    required bool showArrow,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(iconData, color: const Color(0xFF9CA3AF), size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            Text(trailingText, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14)),
            if (showArrow) ...[
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 18),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceSwitchTile({
    required IconData iconData,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(iconData, color: const Color(0xFF9CA3AF), size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          ),
          Switch.adaptive(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF8B5CF6),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: Color(0xFF27272A), height: 1),
    );
  }

  

 
}