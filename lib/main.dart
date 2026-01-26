// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';
import 'config/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Ambil router dari provider
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(  // ✅ Ganti MaterialApp → MaterialApp.router
      title: 'Siswa App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      
      // ✅ Konfigurasi router
      routerConfig: router,
    );
  }
}

// Screen untuk cek login status
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: StorageService().isLoggedIn(),
      builder: (context, snapshot) {
        // Kalau masih loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Kalau sudah dapat hasil
        final isLoggedIn = snapshot.data ?? false;

        // Redirect ke screen yang sesuai
        if (isLoggedIn) {
          return const HomeScreen();  // Sudah login → Home
        } else {
          return const LoginScreen(); // Belum login → Login
        }
      },
    );
  }
}