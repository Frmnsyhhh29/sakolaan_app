// lib/screens/mapel/mapel_detail_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/mapel_model.dart';
import '../../services/mapel_service.dart';

class MapelDetailPage extends StatefulWidget {
  final String mapelId;

  const MapelDetailPage({
    super.key,
    required this.mapelId,
  });

  @override
  State<MapelDetailPage> createState() => _MapelDetailPageState();
}

class _MapelDetailPageState extends State<MapelDetailPage> {
<<<<<<< Updated upstream
  late Future<Mapel?> _mapelFuture; // Ubah ke nullable
=======
  late Future<Mapel> _mapelFuture;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
<<<<<<< Updated upstream
    final mapelService = MapelService(); // Buat instance
    _mapelFuture = mapelService.getMapelById(int.parse(widget.mapelId)); // Assign ke variable
=======
    _mapelFuture = MapelService.getMapelById(widget.mapelId);
>>>>>>> Stashed changes
  }

  Future<void> _deleteMapel() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Hapus Mata Pelajaran'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus mata pelajaran ini?',
        ),
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
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

<<<<<<< Updated upstream
      final mapelService = MapelService(); // Buat instance
      final success = await mapelService.deleteMapel(int.parse(widget.mapelId)); // Gunakan instance
=======
      final success = await MapelService.deleteMapel(widget.mapelId);
>>>>>>> Stashed changes

      if (mounted) {
        Navigator.pop(context); // Close loading

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Mata pelajaran berhasil dihapus'
                  : 'Gagal menghapus mata pelajaran',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          context.pop(true); // Kembali ke list
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Icon(Icons.menu_book, color: Colors.green.shade600),
            const SizedBox(width: 12),
            const Text(
              'Detail Mata Pelajaran',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.blue.shade600,
            tooltip: 'Edit',
            onPressed: () async {
              final result = await context.push('/mapel/edit/${widget.mapelId}');
              if (result == true) {
                setState(() => _loadData());
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red.shade600,
            tooltip: 'Hapus',
            onPressed: _deleteMapel,
          ),
        ],
      ),

<<<<<<< Updated upstream
      body: FutureBuilder<Mapel?>(
=======
      body: FutureBuilder<Mapel>(
>>>>>>> Stashed changes
        future: _mapelFuture,
        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR
<<<<<<< Updated upstream
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
=======
          if (snapshot.hasError) {
>>>>>>> Stashed changes
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi kesalahan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
<<<<<<< Updated upstream
                      snapshot.hasError ? '${snapshot.error}' : 'Data tidak ditemukan',
=======
                      '${snapshot.error}',
>>>>>>> Stashed changes
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _loadData()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // DATA
          final mapel = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CARD INFORMASI
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
<<<<<<< Updated upstream
                            color: Colors.black.withValues(alpha: 0.05),
=======
                            color: Colors.black.withAlpha(13),
>>>>>>> Stashed changes
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HEADER
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.menu_book,
                                  color: Colors.green.shade600,
                                  size: 32,
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Kode: ${mapel.kodeMapel}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const Divider(height: 32),

                          // DETAIL INFO
                          _detailRow(
                            Icons.person_outline,
                            'Guru Pengampu',
<<<<<<< Updated upstream
                            mapel.guruPengampu ?? '-',
=======
                            mapel.guruPengampu,
>>>>>>> Stashed changes
                          ),
                          const SizedBox(height: 16),
                          _detailRow(
                            Icons.schedule_outlined,
                            'Jam Pelajaran',
<<<<<<< Updated upstream
                            mapel.jamPelajaran ?? '-',
=======
                            '${mapel.jamPelajaran} jam/minggu',
>>>>>>> Stashed changes
                          ),

                          if (mapel.deskripsi != null &&
                              mapel.deskripsi!.isNotEmpty) ...[
                            const Divider(height: 32),
                            _detailRow(
                              Icons.description_outlined,
                              'Deskripsi',
                              mapel.deskripsi!,
                              multiline: true,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    bool multiline = false,
  }) {
    return Row(
      crossAxisAlignment:
          multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 22, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}