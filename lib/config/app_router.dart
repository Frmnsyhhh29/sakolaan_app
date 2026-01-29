// lib/config/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percobaan1/screens/guru/guru_page.dart';
import 'package:percobaan1/screens/guru/guru_tambah_page.dart';
import 'package:percobaan1/screens/mapel/mapel_page.dart';

// AUTH
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';

// HOME
import '../screens/home_screen.dart';

// SISWA
import '../screens/siswa/siswa_page.dart';
import '../screens/siswa/siswa_tambah_page.dart';
import '../screens/siswa/siswa_edit_page.dart';

// KELAS
import 'package:percobaan1/screens/kelas/kelas_page.dart';
import 'package:percobaan1/screens/kelas/kelas_detail_page.dart';
import 'package:percobaan1/screens/kelas/kelas_tambah_page.dart';

// MAPEL
import 'package:percobaan1/screens/mapel/mapel_page.dart';
import 'package:percobaan1/screens/mapel/mapel_tambah_page.dart';
import 'package:percobaan1/screens/mapel/mapel_detail_page.dart';
import 'package:percobaan1/screens/mapel/mapel_edit_page.dart';

// ✅ NILAI
import 'package:percobaan1/screens/nilai/nilai_page.dart';
import 'package:percobaan1/screens/nilai/nilai_tambah_page.dart';
import 'package:percobaan1/screens/nilai/nilai_detail_page.dart';
import 'package:percobaan1/screens/nilai/nilai_edit_page.dart';

// SERVICE
import '../services/storage_service.dart';

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
      // ======================
      // PUBLIC ROUTES
      // ======================
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
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // ---------- SISWA ----------
      GoRoute(
        path: '/siswa',
        name: 'siswa',
        builder: (context, state) => const SiswaPage(),
      ),

      GoRoute(
        path: '/siswa/tambah',
        name: 'siswa-tambah',
        builder: (context, state) => const SiswaTambahPage(),
      ),

      // ✅ PERBAIKAN: Hapus int.parse(), langsung kirim String
      GoRoute(
        path: '/siswa/edit/:id',
        name: 'siswa-edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SiswaEditPage(siswaId: id); // ✅ Langsung String
        },
      ),

      // ---------- KELAS ----------
      GoRoute(
        path: '/kelas',
        name: 'kelas',
        builder: (context, state) => const KelasPage(),
      ),

      GoRoute(
        path: '/kelas/tambah',
        name: 'kelas-tambah',
        builder: (context, state) => const KelasTambahPage(),
      ),

      GoRoute(
        path: '/kelas/detail/:id',
        name: 'kelas-detail',
        builder: (context, state) {
          final kelasId = state.pathParameters['id']!;
          return KelasDetailPage(kelasId: kelasId);
        },
      ),

      // ---------- MAPEL ----------
      GoRoute(
        path: '/mapel',
        name: 'mapel',
        builder: (context, state) => const MapelPage(),
      ),

      GoRoute(
        path: '/mapel/tambah',
        name: 'mapel-tambah',
        builder: (context, state) => const MapelTambahPage(),
      ),

      GoRoute(
        path: '/mapel/detail/:id',
        name: 'mapel-detail',
        builder: (context, state) {
          final mapelId = state.pathParameters['id']!;
          return MapelDetailPage(mapelId: mapelId);
        },
      ),

      GoRoute(
        path: '/guru', 
        name: 'guru',
        builder: (context, state) => const GuruPage(),
      ),

      GoRoute(
        path: '/guru/tambah', 
        name: 'guru-tambah',
        builder: (context, state) => const GuruTambahPage(),
      ),

      GoRoute(
        path: '/mapel', 
        name: 'mapel',
        builder: (context, state) => const MapelPage(),
      ),

      // ✅ ---------- NILAI ----------
      GoRoute(
        path: '/nilai',
        name: 'nilai',
        builder: (context, state) => const NilaiPage(),
      ),

      GoRoute(
        path: '/nilai/tambah',
        name: 'nilai-tambah',
        builder: (context, state) => const NilaiTambahPage(),
      ),

      GoRoute(
        path: '/nilai/detail/:id',
        name: 'nilai-detail',
        builder: (context, state) {
          final nilaiId = state.pathParameters['id']!;
          return NilaiDetailPage(nilaiId: nilaiId);
        },
      ),

      GoRoute(
        path: '/nilai/edit/:id',
        name: 'nilai-edit',
        builder: (context, state) {
          final nilaiId = state.pathParameters['id']!;
          return NilaiEditPage(nilaiId: nilaiId);
        },
      ),
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