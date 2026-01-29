// lib/screens/siswa/siswa_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/siswa_model.dart';
import '../../models/kelas_model.dart';
import '../../providers/siswa_provider.dart';
import '../../services/kelas_service.dart';

class SiswaPage extends ConsumerStatefulWidget {
  const SiswaPage({super.key});

  @override
  ConsumerState<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends ConsumerState<SiswaPage> {
  final searchController = TextEditingController();
  
  // ✅ FILTER PER KELAS
  List<Kelas> _kelasList = [];
  String? _selectedKelasFilter;
  // ✅ HAPUS FIELD YANG TIDAK TERPAKAI
  // bool _isLoadingKelas = false; ← DIHAPUS
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(siswaProvider.notifier).fetchSiswa();
      _loadKelas();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ✅ Load kelas untuk filter
  Future<void> _loadKelas() async {
    // ✅ HAPUS setState karena _isLoadingKelas dihapus
    try {
      final kelas = await KelasService.getKelas();
      if (mounted) {
        setState(() {
          _kelasList = kelas;
        });
      }
    } catch (e) {
      // Handle error jika perlu
      print('Error loading kelas: $e');
    }
  }

  // ✅ Filter siswa berdasarkan kelas
  List<Siswa> _filterSiswaByKelas(List<Siswa> siswaList) {
    if (_selectedKelasFilter == null || _selectedKelasFilter == 'all') {
      return siswaList;
    }
    
    return siswaList.where((siswa) {
      return siswa.kelasId == _selectedKelasFilter;
    }).toList();
  }

  // Search filter
  List<Siswa> _filterSiswa(List<Siswa> siswaList) {
    if (searchController.text.isEmpty) {
      return _filterSiswaByKelas(siswaList);
    }
    
    final query = searchController.text.toLowerCase();
    final filtered = siswaList.where((siswa) {
      return siswa.nama.toLowerCase().contains(query) ||
          siswa.nis.toLowerCase().contains(query) ||
          (siswa.kelas?.toLowerCase().contains(query) ?? false);
    }).toList();
    
    return _filterSiswaByKelas(filtered);
  }

  @override
  Widget build(BuildContext context) {
    final siswaState = ref.watch(siswaProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 32,
              vertical: isMobile ? 16 : 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05), // ✅ PERBAIKI
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Kembali',
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.people,
                        color: Colors.blue.shade600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data Siswa',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Kelola data siswa sekolah',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/siswa/tambah'),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(isMobile ? 'Tambah' : 'Tambah Siswa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // ✅ SEARCH & FILTER SECTION
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Search bar
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari siswa (nama, NIS, kelas)...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // ✅ FILTER DROPDOWN KELAS - PERBAIKI initialValue
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _selectedKelasFilter,
                        decoration: InputDecoration(
                          labelText: 'Filter Kelas',
                          prefixIcon: const Icon(Icons.filter_list),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: 'all',
                            child: Text('Semua Kelas'),
                          ),
                          ..._kelasList.map((kelas) {
                            return DropdownMenuItem(
                              value: kelas.id,
                              child: Text(kelas.displayName),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedKelasFilter = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: siswaState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : siswaState.hasError // ✅ PERBAIKI: Gunakan hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 64, color: Colors.red.shade300),
                            const SizedBox(height: 16),
                            Text(
                              siswaState.errorMessage ?? 'Terjadi kesalahan', // ✅ PERBAIKI
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(siswaProvider.notifier).fetchSiswa();
                              },
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      )
                    : _buildSiswaList(
                        _filterSiswa(siswaState.siswaList),
                        isMobile,
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSiswaList(List<Siswa> siswaList, bool isMobile) {
    if (siswaList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              searchController.text.isNotEmpty || _selectedKelasFilter != null
                  ? 'Tidak ada siswa yang sesuai filter'
                  : 'Belum ada data siswa',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            if (searchController.text.isEmpty && _selectedKelasFilter == null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.push('/siswa/tambah'),
                icon: const Icon(Icons.add),
                label: const Text('Tambah Siswa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      itemCount: siswaList.length,
      itemBuilder: (context, index) {
        final siswa = siswaList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                siswa.nama[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              siswa.nama,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('NIS: ${siswa.nis}'),
                Text('Kelas: ${siswa.displayKelas}'),
                if (siswa.jenisKelamin != null)
                  Text('JK: ${siswa.displayJenisKelamin}'),
              ],
            ),
            trailing: PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 12),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Hapus', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  context.push('/siswa/edit/${siswa.id}');
                } else if (value == 'delete') {
                  _confirmDelete(siswa);
                }
              },
            ),
            onTap: () => context.push('/siswa/detail/${siswa.id}'),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(Siswa siswa) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus data ${siswa.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      // ✅ PERBAIKI: siswa.id sudah String, tidak perlu toString()
      final success = await ref
          .read(siswaProvider.notifier)
          .deleteSiswa(siswa.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Data berhasil dihapus'
                  : 'Gagal menghapus data',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}