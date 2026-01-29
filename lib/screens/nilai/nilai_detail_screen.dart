import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/models/nilai.dart';
import '/providers/nilai_provider.dart';

class NilaiDetailScreen extends ConsumerStatefulWidget {
  final String nilaiId;

  const NilaiDetailScreen({super.key, required this.nilaiId});

  @override
  ConsumerState<NilaiDetailScreen> createState() => _NilaiDetailScreenState();
}

class _NilaiDetailScreenState extends ConsumerState<NilaiDetailScreen> {
  Nilai? _nilai;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNilaiDetail();
  }

  Future<void> _loadNilaiDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final nilaiService = ref.read(nilaiServiceProvider);
      final nilai = await nilaiService.getNilaiById(int.parse(widget.nilaiId));
      
      setState(() {
        _nilai = nilai;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteNilai() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus nilai ini?'),
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
      final success = await ref.read(nilaiProvider.notifier).deleteNilai(int.parse(widget.nilaiId));
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nilai berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus nilai'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const Text(
          'Detail Nilai',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          if (!_isLoading && _nilai != null) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push('/nilai/edit/${widget.nilaiId}'),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
              onPressed: _deleteNilai,
              tooltip: 'Hapus',
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadNilaiDetail,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : _nilai == null
                  ? const Center(child: Text('Data tidak ditemukan'))
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(isMobile ? 16 : 24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Header Card - Grade & Nilai Akhir
                              Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: _getGradeColor(_nilai!.grade),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      Text(
                                        _nilai!.grade,
                                        style: const TextStyle(
                                          fontSize: 72,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Nilai Akhir: ${_nilai!.nilaiAkhir.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getGradeDescription(_nilai!.grade),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Info Siswa & Mapel
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Informasi',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Divider(height: 24),
                                      _buildInfoRow(
                                        icon: Icons.person_outline,
                                        label: 'Nama Siswa',
                                        value: _nilai!.siswa?.nama ?? '-',
                                      ),
                                      _buildInfoRow(
                                        icon: Icons.badge_outlined,
                                        label: 'NIS',
                                        value: _nilai!.siswa?.nis ?? '-',
                                      ),
                                      _buildInfoRow(
                                        icon: Icons.book_outlined,
                                        label: 'Mata Pelajaran',
                                        value: _nilai!.mapel?.namaMapel ?? '-',
                                      ),
                                      _buildInfoRow(
                                        icon: Icons.code,
                                        label: 'Kode Mapel',
                                        value: _nilai!.mapel?.kodeMapel ?? '-',
                                      ),
                                      _buildInfoRow(
                                        icon: Icons.calendar_today_outlined,
                                        label: 'Semester',
                                        value: _nilai!.semester,
                                      ),
                                      _buildInfoRow(
                                        icon: Icons.calendar_month_outlined,
                                        label: 'Tahun Ajaran',
                                        value: _nilai!.tahunAjaran.toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Detail Nilai
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Rincian Nilai',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Divider(height: 24),
                                      _buildNilaiRow(
                                        'Nilai Tugas',
                                        _nilai!.nilaiTugas,
                                        '30%',
                                        Colors.blue,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildNilaiRow(
                                        'Nilai UTS',
                                        _nilai!.nilaiUts,
                                        '30%',
                                        Colors.orange,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildNilaiRow(
                                        'Nilai UAS',
                                        _nilai!.nilaiUas,
                                        '40%',
                                        Colors.purple,
                                      ),
                                      const Divider(height: 24),
                                      _buildNilaiRow(
                                        'Nilai Akhir',
                                        _nilai!.nilaiAkhir,
                                        '100%',
                                        Colors.teal,
                                        isFinal: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Catatan (jika ada)
                              if (_nilai!.catatan != null && _nilai!.catatan!.isNotEmpty) ...[
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.note_outlined, color: Colors.grey.shade600),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Catatan',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(height: 24),
                                        Text(
                                          _nilai!.catatan!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade700,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Timestamp
                              Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.add_circle_outline, size: 16, color: Colors.grey.shade600),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Dibuat: ${_formatDate(_nilai!.createdAt)}',
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.update_outlined, size: 16, color: Colors.grey.shade600),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Diupdate: ${_formatDate(_nilai!.updatedAt)}',
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
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
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNilaiRow(String label, double nilai, String bobot, Color color, {bool isFinal = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isFinal ? 16 : 14,
                    fontWeight: isFinal ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                Text(
                  'Bobot: $bobot',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            nilai.toStringAsFixed(2),
            style: TextStyle(
              fontSize: isFinal ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green.shade600;
      case 'B':
        return Colors.blue.shade600;
      case 'C':
        return Colors.orange.shade600;
      case 'D':
        return Colors.deepOrange.shade600;
      case 'E':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  String _getGradeDescription(String grade) {
    switch (grade) {
      case 'A':
        return 'Sangat Baik (90-100)';
      case 'B':
        return 'Baik (80-89)';
      case 'C':
        return 'Cukup (70-79)';
      case 'D':
        return 'Kurang (60-69)';
      case 'E':
        return 'Sangat Kurang (<60)';
      default:
        return '';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}