// lib/screens/mapel/mapel_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/mapel_model.dart';
import '../../services/mapel_service.dart';

class MapelPage extends ConsumerStatefulWidget {
  const MapelPage({super.key});

  @override
  ConsumerState<MapelPage> createState() => _MapelPageState();
}

class _MapelPageState extends ConsumerState<MapelPage> {
  String _searchQuery = '';
  late Future<List<Mapel>> _mapelFuture;

  @override
  void initState() {
    super.initState();
    _mapelFuture = MapelService.getMapel();
  }

  void _refreshData() {
    setState(() {
      _mapelFuture = MapelService.getMapel();
    });
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
            Icon(Icons.menu_book, color: Colors.green.shade600),
            const SizedBox(width: 10),
            const Text(
              'Daftar Mata Pelajaran',
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
                      hintText: 'Cari mapel (contoh: Matematika)',
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
                    await context.push('/mapel/tambah');
                    _refreshData();
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
            child: FutureBuilder<List<Mapel>>(
              future: _mapelFuture,
              builder: (context, snapshot) {
                // LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                      'Belum ada mata pelajaran',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                // FILTER
                final mapelList = snapshot.data!
                    .where((m) =>
                        m.namaMapel
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        m.kodeMapel
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                    .toList();

                if (mapelList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Mata pelajaran tidak ditemukan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: mapelList.length,
                  itemBuilder: (context, index) {
                    final mapel = mapelList[index];

                    return GestureDetector(
                      onTap: () async {
                        await context.push('/mapel/detail/${mapel.id}');
                        _refreshData();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
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
                                Icons.menu_book,
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
                                    mapel.namaMapel,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Kode: ${mapel.kodeMapel}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Guru: ${mapel.guruPengampu}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${mapel.jamPelajaran} jam/minggu',
                                    style: TextStyle(
                                      fontSize: 12,
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