// lib/screens/siswa/siswa_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/siswa_model.dart';
import '../../providers/siswa_provider.dart';

class SiswaEditPage extends ConsumerStatefulWidget {
  final int siswaId;

  const SiswaEditPage({
    super.key,
    required this.siswaId,
  });

  @override
  ConsumerState<SiswaEditPage> createState() => _SiswaDetailPageState();
}

class _SiswaDetailPageState extends ConsumerState<SiswaEditPage> {
  late TextEditingController nisController;
  late TextEditingController namaController;
  late TextEditingController kelasController;
  late TextEditingController alamatController;
  late TextEditingController noHpController;

  @override
  void initState() {
    super.initState();
    nisController = TextEditingController();
    namaController = TextEditingController();
    kelasController = TextEditingController();
    alamatController = TextEditingController();
    noHpController = TextEditingController();
  }

  @override
  void dispose() {
    nisController.dispose();
    namaController.dispose();
    kelasController.dispose();
    alamatController.dispose();
    noHpController.dispose();
    super.dispose();
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

  Future<void> _saveChanges(Siswa siswa) async {
    if (namaController.text.isEmpty) {
      _showMessage('Nama harus diisi', isError: true);
      return;
    }

    final updatedSiswa = Siswa(
      nis: nisController.text,
      nama: namaController.text,
      kelas: kelasController.text,
      alamat: alamatController.text,
      noHp: noHpController.text,
    );

    final siswaNotifier = ref.read(siswaProvider.notifier);
    final success = await siswaNotifier.updateSiswa(siswa.id!, updatedSiswa);

    if (success) {
      _showMessage('Data berhasil diupdate');
      if (mounted) {
        context.go('/siswa');
      }
    } else {
      _showMessage('Gagal mengupdate data', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final siswaState = ref.watch(siswaProvider);

    // Cari siswa berdasarkan ID
    final siswa = siswaState.siswaList.firstWhere(
      (s) => s.id == widget.siswaId,
      orElse: () => Siswa(
        id: 0,
        nis: '',
        nama: 'Tidak ditemukan',
        kelas: '',
        alamat: '',
        noHp: '',
      ),
    );

    // Set initial values
    if (siswa.id != 0 && nisController.text.isEmpty) {
      nisController.text = siswa.nis;
      namaController.text = siswa.nama;
      kelasController.text = siswa.kelas;
      alamatController.text = siswa.alamat;
      noHpController.text = siswa.noHp;
    }

    // Kalau data tidak ditemukan
    if (siswa.id == 0) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
              const SizedBox(height: 16),
              const Text(
                'Data siswa tidak ditemukan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go('/siswa'),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke List'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
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
                  onPressed: () => context.go('/siswa'),
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Kembali',
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.green.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Data Siswa',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ubah informasi data siswa',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.go('/siswa'),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Batal'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _saveChanges(siswa),
                  icon: const Icon(Icons.save, size: 18),
                  label: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Siswa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: nisController,
                                decoration: InputDecoration(
                                  labelText: 'NIS',
                                  prefixIcon: const Icon(Icons.badge),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: kelasController,
                                decoration: InputDecoration(
                                  labelText: 'Kelas',
                                  prefixIcon: const Icon(Icons.school),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: namaController,
                          decoration: InputDecoration(
                            labelText: 'Nama Lengkap',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: alamatController,
                          decoration: InputDecoration(
                            labelText: 'Alamat',
                            prefixIcon: const Icon(Icons.home),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: noHpController,
                          decoration: InputDecoration(
                            labelText: 'No HP',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}