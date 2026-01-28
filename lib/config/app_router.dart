// lib/config/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percobaan1/screens/guru/guru_page.dart';
import 'package:percobaan1/screens/guru/guru_tambah_page.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/siswa/siswa_edit_page.dart';
import '../screens/siswa/siswa_page.dart';
import '../services/storage_service.dart';
import '../screens/siswa/siswa_tambah_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,

    redirect: (context, state) async {
      final storageService = StorageService();
      final isLoggedIn = await storageService.isLoggedIn();
      final currentPath = state.uri.path;
      final publicPaths = ['/login', '/register'];

      if (!isLoggedIn && !publicPaths.contains(currentPath)) {
        return '/login';
      }

      if (isLoggedIn && publicPaths.contains(currentPath)) {
        return '/home';
      }

      if (currentPath == '/') {
        return isLoggedIn ? '/home' : '/login';
      }

      return null;
    },

    routes: [
      // PUBLIC ROUTES
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // PROTECTED ROUTES
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '/siswa',
        name: 'siswa',
        builder: (context, state) => const SiswaPage(),
      ),

      GoRoute(
        path: '/siswa/tambah',
        builder: (context, state) => const SiswaTambahPage(),
      ),

      GoRoute(
        path: '/siswa/:id',
        name: 'siswa-edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SiswaEditPage(siswaId: int.parse(id));
        },
      ),

      GoRoute(
        path: '/guru', 
        name: 'guru',
        builder: (context, state) => const GuruPage(),
      ),

      GoRoute(
        path: '/mapel/tambah', 
        name: 'guru-tambah',
        builder: (context, state) => const GuruTambahPage(),
      ),

      // GoRoute(path: '/nilai', name: 'nilai', builder:(context, state) => const NilaiPage(),)
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Path: ${state.uri.path}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    ),
  );
});
