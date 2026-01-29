import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/nilai_provider.dart';

class NilaiPage extends ConsumerStatefulWidget {
  const NilaiPage({super.key});

  @override
  ConsumerState<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends ConsumerState<NilaiPage> {
  String? selectedSemester;
  int? selectedTahun;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nilaiProvider.notifier).loadNilai();
    });
  }

  @override
  Widget build(BuildContext context) {
    final nilaiState = ref.watch(nilaiProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const Text(
          'Daftar Nilai',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter',
          ),
        ],
      ),
      body: nilaiState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : nilaiState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${nilaiState.error}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(nilaiProvider.notifier).loadNilai(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : nilaiState.nilaiList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(isMobile ? 16 : 24),
                      itemCount: nilaiState.nilaiList.length,
                      itemBuilder: (context, index) {
                        final nilai = nilaiState.nilaiList[index];
                        return _buildNilaiCard(nilai, isMobile);
                      },
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('nilai-tambah'),
        backgroundColor: Colors.teal.shade600,
        icon: const Icon(Icons.add),
        label: Text(isMobile ? 'Tambah' : 'Tambah Nilai'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Belum ada data nilai',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap tombol + untuk menambah',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildNilaiCard(nilai, bool isMobile) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.pushNamed('nilai-detail', pathParameters: {'id': nilai.id.toString()}),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getGradeColor(nilai.grade),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      nilai.grade,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nilai.siswa?.nama ?? 'Siswa tidak ditemukan',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          nilai.mapel?.namaMapel ?? 'Mapel tidak ditemukan',
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
              const Divider(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildScoreItem('Tugas', nilai.nilaiTugas),
                  ),
                  Expanded(
                    child: _buildScoreItem('UTS', nilai.nilaiUts),
                  ),
                  Expanded(
                    child: _buildScoreItem('UAS', nilai.nilaiUas),
                  ),
                  Expanded(
                    child: _buildScoreItem('Akhir', nilai.nilaiAkhir, bold: true),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${nilai.semester} ${nilai.tahunAjaran}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, double score, {bool bold = false}) {
    return Column(
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
          score.toStringAsFixed(1),
          style: TextStyle(
            fontSize: bold ? 18 : 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: bold ? Colors.teal.shade700 : Colors.black87,
          ),
        ),
      ],
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Filter Nilai'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Semester'),
              value: selectedSemester,
              items: ['Ganjil', 'Genap']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) => setState(() => selectedSemester = val),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Tahun Ajaran'),
              value: selectedTahun,
              items: List.generate(5, (i) => DateTime.now().year - i)
                  .map((y) => DropdownMenuItem(value: y, child: Text(y.toString())))
                  .toList(),
              onChanged: (val) => setState(() => selectedTahun = val),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedSemester = null;
                selectedTahun = null;
              });
              ref.read(nilaiProvider.notifier).loadNilai();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(nilaiProvider.notifier).loadNilai(
                    semester: selectedSemester,
                    tahunAjaran: selectedTahun,
                  );
              Navigator.pop(context);
            },
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }
}