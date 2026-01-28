import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/nilai.dart';
import '../../providers/nilai_provider.dart';
import '../../services/siswa_service.dart';
import '../../services/mapel_service.dart';

class NilaiTambahPage extends ConsumerStatefulWidget {
  const NilaiTambahPage({super.key});

  @override
  ConsumerState<NilaiTambahPage> createState() => _NilaiTambahPageState();
}

class _NilaiTambahPageState extends ConsumerState<NilaiTambahPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form fields
  int? _selectedSiswaId;
  int? _selectedMapelId;
  String _semester = 'Ganjil';
  int _tahunAjaran = DateTime.now().year;
  final _nilaiTugasController = TextEditingController();
  final _nilaiUtsController = TextEditingController();
  final _nilaiUasController = TextEditingController();
  final _catatanController = TextEditingController();

  // Data untuk dropdown
  List<Map<String, dynamic>> _siswaList = [];
  List<Map<String, dynamic>> _mapelList = [];

  // Nilai yang dihitung
  double _nilaiAkhir = 0;
  String _grade = '-';

  @override
  void initState() {
    super.initState();
    _loadDropdownData();

    // Listen to value changes
    _nilaiTugasController.addListener(_hitungNilaiAkhir);
    _nilaiUtsController.addListener(_hitungNilaiAkhir);
    _nilaiUasController.addListener(_hitungNilaiAkhir);
  }

  Future<void> _loadDropdownData() async {
    try {
      final siswaService = SiswaService();
      final mapelService = MapelService();

      final siswa = await siswaService.getAllSiswa();
      final mapels = await MapelService.getAllMapel();

      setState(() {
        _siswaList = siswa.map((s) {
          // Parse id ke int jika masih String
          final id = s.id is String ? int.parse(s.id!) : s.id;
          return {'id': id, 'nama': s.nama};
        }).toList();
        
        _mapelList = mapels.map((m) {
          // Parse id ke int jika masih String
          final id = m.id is String ? int.parse(m.id.toString()) : m.id;
          return {'id': id, 'nama': m.namaMapel};
        }).toList();
      });
    } catch (e) {
      _showError('Gagal memuat data: $e');
    }
  }

  void _hitungNilaiAkhir() {
    final tugas = double.tryParse(_nilaiTugasController.text) ?? 0;
    final uts = double.tryParse(_nilaiUtsController.text) ?? 0;
    final uas = double.tryParse(_nilaiUasController.text) ?? 0;

    // Bobot: Tugas 30%, UTS 30%, UAS 40%
    final akhir = (tugas * 0.3) + (uts * 0.3) + (uas * 0.4);

    String grade;
    if (akhir >= 90) {
      grade = 'A';
    } else if (akhir >= 80) {
      grade = 'B';
    } else if (akhir >= 70) {
      grade = 'C';
    } else if (akhir >= 60) {
      grade = 'D';
    } else {
      grade = 'E';
    }

    setState(() {
      _nilaiAkhir = akhir;
      _grade = grade;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSiswaId == null || _selectedMapelId == null) {
      _showError('Pilih siswa dan mata pelajaran');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final nilai = Nilai(
        id: 0,
        siswaId: _selectedSiswaId!,
        mapelId: _selectedMapelId!,
        semester: _semester,
        tahunAjaran: _tahunAjaran,
        nilaiTugas: double.parse(_nilaiTugasController.text),
        nilaiUts: double.parse(_nilaiUtsController.text),
        nilaiUas: double.parse(_nilaiUasController.text),
        nilaiAkhir: _nilaiAkhir,
        grade: _grade,
        catatan: _catatanController.text.isEmpty ? null : _catatanController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = await ref.read(nilaiProvider.notifier).addNilai(nilai);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nilai berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else {
        _showError('Gagal menyimpan nilai');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _nilaiTugasController.dispose();
    _nilaiUtsController.dispose();
    _nilaiUasController.dispose();
    _catatanController.dispose();
    super.dispose();
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
          'Tambah Nilai',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Card Info
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
                                  'Informasi Siswa & Mata Pelajaran',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Dropdown Siswa
                                DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    labelText: 'Siswa',
                                    prefixIcon: const Icon(Icons.person_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  value: _selectedSiswaId,
                                  items: _siswaList
                                      .map((siswa) => DropdownMenuItem<int>(
                                            value: siswa['id'],
                                            child: Text(siswa['nama']),
                                          ))
                                      .toList(),
                                  onChanged: (val) => setState(() => _selectedSiswaId = val),
                                  validator: (val) => val == null ? 'Pilih siswa' : null,
                                ),
                                const SizedBox(height: 16),

                                // Dropdown Mapel
                                DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    labelText: 'Mata Pelajaran',
                                    prefixIcon: const Icon(Icons.book_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  value: _selectedMapelId,
                                  items: _mapelList
                                      .map((mapel) => DropdownMenuItem<int>(
                                            value: mapel['id'],
                                            child: Text(mapel['nama']),
                                          ))
                                      .toList(),
                                  onChanged: (val) => setState(() => _selectedMapelId = val),
                                  validator: (val) => val == null ? 'Pilih mata pelajaran' : null,
                                ),
                                const SizedBox(height: 16),

                                // Semester & Tahun Ajaran
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Semester',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        value: _semester,
                                        items: ['Ganjil', 'Genap']
                                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                            .toList(),
                                        onChanged: (val) => setState(() => _semester = val!),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: DropdownButtonFormField<int>(
                                        decoration: InputDecoration(
                                          labelText: 'Tahun Ajaran',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        value: _tahunAjaran,
                                        items: List.generate(5, (i) => DateTime.now().year - i)
                                            .map((y) => DropdownMenuItem(
                                                  value: y,
                                                  child: Text(y.toString()),
                                                ))
                                            .toList(),
                                        onChanged: (val) => setState(() => _tahunAjaran = val!),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Card Nilai
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
                                  'Input Nilai',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Nilai Tugas
                                TextFormField(
                                  controller: _nilaiTugasController,
                                  decoration: InputDecoration(
                                    labelText: 'Nilai Tugas (30%)',
                                    prefixIcon: const Icon(Icons.assignment_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) return 'Wajib diisi';
                                    final nilai = double.tryParse(val);
                                    if (nilai == null || nilai < 0 || nilai > 100) {
                                      return 'Nilai harus 0-100';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Nilai UTS
                                TextFormField(
                                  controller: _nilaiUtsController,
                                  decoration: InputDecoration(
                                    labelText: 'Nilai UTS (30%)',
                                    prefixIcon: const Icon(Icons.edit_note_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) return 'Wajib diisi';
                                    final nilai = double.tryParse(val);
                                    if (nilai == null || nilai < 0 || nilai > 100) {
                                      return 'Nilai harus 0-100';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Nilai UAS
                                TextFormField(
                                  controller: _nilaiUasController,
                                  decoration: InputDecoration(
                                    labelText: 'Nilai UAS (40%)',
                                    prefixIcon: const Icon(Icons.assignment_turned_in_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) return 'Wajib diisi';
                                    final nilai = double.tryParse(val);
                                    if (nilai == null || nilai < 0 || nilai > 100) {
                                      return 'Nilai harus 0-100';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Preview Nilai Akhir
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.teal.shade200),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Nilai Akhir:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            _nilaiAkhir.toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal.shade700,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getGradeColor(_grade),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              _grade,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Catatan
                                TextFormField(
                                  controller: _catatanController,
                                  decoration: InputDecoration(
                                    labelText: 'Catatan (Opsional)',
                                    prefixIcon: const Icon(Icons.note_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Button Submit
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Simpan Nilai',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
}