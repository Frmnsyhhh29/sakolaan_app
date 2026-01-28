// lib/screens/kelas/kelas_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/kelas_model.dart';
import '../../services/kelas_service.dart';

class KelasPage extends ConsumerStatefulWidget {
  const KelasPage({super.key});

  @override
  ConsumerState<KelasPage> createState() => _KelasPageState();
}

class _KelasPageState extends ConsumerState<KelasPage> {
  String _searchQuery = '';
  late Future<List<Kelas>> _kelasFuture;

  @override
  void initState() {
    super.initState();
    _kelasFuture = KelasService.getKelas();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      // ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green.shade700),
          onPressed: () => context.go('/home'),
        ),
        title: Row(
          children: [
            Icon(Icons.class_, color: Colors.green.shade600),
            const SizedBox(width: 10),
            const Text(
              'Daftar Kelas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari kelas (contoh: X IPA)',
                      prefixIcon:
                          Icon(Icons.search, color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    await context.push('/kelas/tambah');
                    setState(() {
                      _kelasFuture = KelasService.getKelas();
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: Text(isMobile ? '' : 'Tambah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= CONTENT =================
          Expanded(
            child: FutureBuilder<List<Kelas>>(
              future: _kelasFuture,
              builder: (context, snapshot) {
                // LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // ERROR
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Terjadi kesalahan: ${snapshot.error}'),
                  );
                }

                // EMPTY
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada kelas',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                // FILTER
                final kelasList = snapshot.data!
                    .where((k) => k.namaKelas
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList();

                if (kelasList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Kelas tidak ditemukan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: kelasList.length,
                  itemBuilder: (context, index) {
                    final kelas = kelasList[index];

                    return GestureDetector(
                      onTap: () async {
                        // Navigate ke detail kelas
                        await context.push('/kelas/detail/${kelas.id}');
                        // Refresh data setelah kembali
                        setState(() {
                          _kelasFuture = KelasService.getKelas();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.school,
                                color: Colors.green.shade600,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    kelas.namaKelas,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Wali Kelas: ${kelas.waliKelas}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${kelas.jumlahSiswa} siswa',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey.shade500,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}