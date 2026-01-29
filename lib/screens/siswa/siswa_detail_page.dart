// lib/screens/siswa/siswa_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/siswa_model.dart';
import '../../services/siswa_service.dart';

class SiswaDetailPage extends ConsumerStatefulWidget {
  final String siswaId;

  const SiswaDetailPage({
    super.key,
    required this.siswaId,
  });

  @override
  ConsumerState<SiswaDetailPage> createState() => _SiswaDetailPageState();
}

class _SiswaDetailPageState extends ConsumerState<SiswaDetailPage> {
  final SiswaService _siswaService = SiswaService();
  Siswa? _siswa;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSiswaDetail();
  }

  Future<void> _loadSiswaDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Ambil semua siswa dan cari yang sesuai ID
      final siswaList = await _siswaService.getAllSiswa();
      final siswa = siswaList.firstWhere(
        (s) => s.id == widget.siswaId,
        orElse: () => throw Exception('Siswa tidak ditemukan'),
      );

      if (mounted) {
        setState(() {
          _siswa = siswa;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
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
                    Icons.person,
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
                        'Detail Siswa',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Informasi lengkap siswa',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_siswa != null)
                  ElevatedButton.icon(
                    onPressed: () => context.push('/siswa/edit/${widget.siswaId}'),
                    icon: const Icon(Icons.edit, size: 18),
                    label: Text(isMobile ? 'Edit' : 'Edit Data'),
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
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 64, color: Colors.red.shade300),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadSiswaDetail,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      )
                    : _buildDetailContent(isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContent(bool isMobile) {
    if (_siswa == null) return const SizedBox();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Profil
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    radius: 50,
                    child: Text(
                      _siswa!.nama[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Nama
                  Text(
                    _siswa!.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // NIS
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'NIS: ${_siswa!.nis}',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Informasi Umum
          _buildSectionTitle('Informasi Umum'),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.school,
                  label: 'Kelas',
                  value: _getKelasName(),
                ),
                const Divider(height: 1),
                _buildInfoRow(
                  icon: Icons.wc,
                  label: 'Jenis Kelamin',
                  value: _siswa!.displayJenisKelamin,
                ),
                if (_siswa!.tanggalLahir != null) ...[
                  const Divider(height: 1),
                  _buildInfoRow(
                    icon: Icons.cake,
                    label: 'Tanggal Lahir',
                    value: _siswa!.tanggalLahir!,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Informasi Kontak
          _buildSectionTitle('Informasi Kontak'),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.phone,
                  label: 'No. HP',
                  value: _siswa!.noHp,
                ),
                if (_siswa!.email != null) ...[
                  const Divider(height: 1),
                  _buildInfoRow(
                    icon: Icons.email,
                    label: 'Email',
                    value: _siswa!.email!,
                  ),
                ],
                const Divider(height: 1),
                _buildInfoRow(
                  icon: Icons.home,
                  label: 'Alamat',
                  value: _siswa!.alamat,
                  isMultiline: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Tombol Aksi
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/siswa/edit/${widget.siswaId}'),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Data'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.blue.shade600),
                    foregroundColor: Colors.blue.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _confirmDelete,
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus Data'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getKelasName() {
    if (_siswa?.kelas == null) return 'Belum ada kelas';
    
    // Jika kelas berupa string biasa, return langsung
    if (!_siswa!.kelas!.contains('{')) {
      return _siswa!.kelas!;
    }
    
    // Jika kelas berupa object string, extract nama_kelas
    try {
      // Cari nama_kelas di dalam string object
      final regex = RegExp(r'nama_kelas:\s*([^,}]+)');
      final match = regex.firstMatch(_siswa!.kelas!);
      if (match != null) {
        return match.group(1)?.trim() ?? 'Belum ada kelas';
      }
    } catch (e) {
      print('Error parsing kelas: $e');
    }
    
    return 'Belum ada kelas';
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus data ${_siswa!.nama}?'),
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
      try {
        final success = await _siswaService.deleteSiswa(int.parse(widget.siswaId));

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data berhasil dihapus'),
                backgroundColor: Colors.green,
              ),
            );
            // Kembali ke halaman siswa
            context.go('/siswa');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal menghapus data'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}