// lib/screens/mapel/mapel_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/mapel_model.dart';
import '../../providers/mapel_provider.dart';

class MapelPage extends ConsumerStatefulWidget {
  const MapelPage({super.key});

  @override
  ConsumerState<MapelPage> createState() => _MapelPageState();
}

class _MapelPageState extends ConsumerState<MapelPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(mapelProvider.notifier).loadMapel());
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        width: 400,
      ),
    );
  }

  void _confirmDelete(Mapel mapel) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus mata pelajaran "${mapel.namaMapel}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              final mapelNotifier = ref.read(mapelProvider.notifier);
              final success = await mapelNotifier.deleteMapel(mapel.id!);

              if (success) {
                _showMessage('Data berhasil dihapus');
              } else {
                _showMessage('Gagal menghapus data', isError: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapelState = ref.watch(mapelProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;
    
    final filteredList = mapelState.mapelList
        .where((mapel) =>
            mapel.namaMapel.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            mapel.kodeMapel.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 6,
        backgroundColor: Colors.grey.shade100,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green.shade700),
          onPressed: () => context.go('/home'),
        ),
        title: Row(
          children: [
            Icon(Icons.book, color: Colors.green.shade600, size: isMobile ? 24 : 28),
            const SizedBox(width: 12),
            Text(
              'Data Mata Pelajaran',
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMobile)
                  const Text(
                    'Kelola data mata pelajaran sekolah',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                SizedBox(height: isMobile ? 12 : 16),
                
                // Search & Add Button
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    // Search Bar
                    Container(
                      width: isMobile ? double.infinity : (isTablet ? 300 : 400),
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: (value) => setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          hintText: 'Cari mata pelajaran...',
                          hintStyle: TextStyle(fontSize: isMobile ? 14 : 15),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    // Add Button
                    SizedBox(
                      width: isMobile ? double.infinity : null,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/mapel/tambah'),
                        icon: const Icon(Icons.add, size: 20),
                        label: Text(isMobile ? 'Tambah' : 'Tambah Mata Pelajaran'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content Section
          Expanded(
            child: Builder(
              builder: (context) {
                if (mapelState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (mapelState.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 80, color: Colors.red.shade300),
                          const SizedBox(height: 16),
                          const Text(
                            'Terjadi Kesalahan',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mapelState.errorMessage!,
                            style: TextStyle(color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () =>
                                ref.read(mapelProvider.notifier).loadMapel(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (mapelState.mapelList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book_outlined,
                              size: 100, color: Colors.grey.shade300),
                          const SizedBox(height: 24),
                          const Text(
                            'Belum ada data mata pelajaran',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Klik tombol "Tambah Mata Pelajaran" untuk menambahkan data',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text(
                          'Tidak ada hasil',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Coba kata kunci pencarian yang lain',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(mapelProvider.notifier).refreshMapel();
                  },
                  child: isMobile 
                    ? _buildMobileList(filteredList) 
                    : _buildDesktopTable(filteredList, mapelState, isTablet),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Mobile List View
  Widget _buildMobileList(List<Mapel> filteredList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final mapel = filteredList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: InkWell(
            onTap: () => context.go('/mapel/${mapel.id}'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.book,
                          color: Colors.green.shade600,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
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
                            const SizedBox(height: 4),
                            Text(
                              'Kode: ${mapel.kodeMapel}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.go('/mapel/${mapel.id}'),
                        icon: Icon(Icons.edit_outlined, color: Colors.green.shade600),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        onPressed: () => _confirmDelete(mapel),
                        icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                        tooltip: 'Hapus',
                      ),
                    ],
                  ),
                  if (mapel.deskripsi != null && mapel.deskripsi!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      mapel.deskripsi!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (mapel.siswaCount != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${mapel.siswaCount} siswa',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Desktop Table View
  Widget _buildDesktopTable(List<Mapel> filteredList, mapelState, bool isTablet) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 16 : 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Card
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Mata Pelajaran',
                      mapelState.mapelList.length.toString(),
                      Icons.book_outlined,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Hasil Pencarian',
                      filteredList.length.toString(),
                      Icons.search,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Table
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 60),
                          _buildTableHeader('Kode Mapel', flex: 2),
                          _buildTableHeader('Nama Mata Pelajaran', flex: 3),
                          _buildTableHeader('Deskripsi', flex: 4),
                          const SizedBox(width: 100),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Table Body
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final mapel = filteredList[index];
                        return InkWell(
                          onTap: () => context.go('/mapel/${mapel.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.book,
                                    color: Colors.green.shade600,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _buildTableCell(mapel.kodeMapel, flex: 2, bold: true),
                                _buildTableCell(mapel.namaMapel, flex: 3),
                                _buildTableCell(
                                  mapel.deskripsi ?? '-',
                                  flex: 4,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () => context.go('/mapel/${mapel.id}'),
                                        icon: Icon(Icons.edit_outlined, color: Colors.green.shade600),
                                        tooltip: 'Edit',
                                      ),
                                      IconButton(
                                        onPressed: () => _confirmDelete(mapel),
                                        icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                                        tooltip: 'Hapus',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {int flex = 1, bool bold = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          color: bold ? Colors.black87 : Colors.grey.shade700,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}