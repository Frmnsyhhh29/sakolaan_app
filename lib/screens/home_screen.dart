// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../config/app_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 6,
        backgroundColor: Colors.grey.shade100,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.school, color: Colors.green.shade600, size: isMobile ? 24 : 28),
            const SizedBox(width: 12),
            Text(
              'Sakolaan App',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          if (!isMobile) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade600,
                    radius: 18,
                    child: Text(
                      user?.name != null && user!.name.isNotEmpty 
                          ? user.name[0].toUpperCase() 
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _showLogoutDialog(context, ref),
                    icon: Icon(Icons.logout, color: Colors.red.shade600),
                    tooltip: 'Logout',
                  ),
                ],
              ),
            ),
          ],
          if (isMobile) ...[
            PopupMenuButton<String>(
              icon: CircleAvatar(
                backgroundColor: Colors.green.shade600,
                radius: 16,
                child: Text(
                  user?.name != null && user!.name.isNotEmpty 
                      ? user.name[0].toUpperCase() 
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'User',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 18, color: Colors.red.shade600),
                      const SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'logout') {
                  _showLogoutDialog(context, ref);
                }
              },
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 20 : 32),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We,come Baraya',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Selamat datang kembali',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu Utama',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: isMobile ? 16 : 24),

                      // Menu Grid - Responsive
                      LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);
                          double childAspectRatio = isMobile ? 3 : (isTablet ? 2 : 1.4);
                          
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: isMobile ? 12 : 10,
                            crossAxisSpacing: isMobile ? 12 : 10,
                            childAspectRatio: childAspectRatio,
                            children: [
                              _buildMenuCard(
                                context,
                                isMobile: isMobile,
                                icon: Icons.people_outline,
                                title: 'Data Siswa',
                                color: Colors.green.shade600,
                                onTap: () => context.go('/siswa'),
                              ),
                              _buildMenuCard(
                                context,
                                isMobile: isMobile,
                                icon: Icons.school_outlined,
                                title: 'Data Guru',
                                color: Colors.green.shade600,
                                onTap: () => context.go('/guru'),
                              ),
                              _buildMenuCard(
                                context,
                                isMobile: isMobile,
                                icon: Icons.class_outlined,
                                title: 'Kelas',

                                color: Colors.green.shade600,
                                onTap: () => context.push('/kelas'),
                              ),
                              _buildMenuCard(
                                context,
                                isMobile: isMobile,
                                icon: Icons.menu_book_outlined,
                                title: 'Mata Pelajaran',
                                color: Colors.green.shade600,
                                onTap: () => context.push('/mapel'),
                              ),
                              // ✅ PERBAIKAN: Menu Nilai sekarang navigasi ke /nilai
                              _buildMenuCard(
                                context,
                                isMobile: isMobile,
                                icon: Icons.assignment_outlined,
                                title: 'Nilai',
                                color: Colors.green.shade600,
                                onTap: () => context.push('/nilai'), // ✅ DIPERBAIKI

                          

                              ),
                              _buildMenuCard(
                                context,
                                isMobile: isMobile,
                                icon: Icons.fact_check_outlined,
                                title: 'Absensi',
                                color: Colors.green.shade600,
                                onTap: () => context.push('/nilai'),
                              ),
                              _buildMenuCard(
                                context,
                                isMobile: isMobile,
                                icon: Icons.campaign_outlined,
                                title: 'Pengumuman',
                                color: Colors.green.shade600,
                                onTap: () => context.push('/pengumuman'),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required bool isMobile,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: isMobile
              ? Row(
                  children: [
                    Icon(icon, size: 32, color: color),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 48, color: color),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature belum tersedia'),
        behavior: SnackBarBehavior.floating,
        width: 300,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await ref.read(authProvider.notifier).logout();
      ref.invalidate(goRouterProvider);
      
      if (context.mounted) {
        context.go('/login');
      }
    }
  }
}