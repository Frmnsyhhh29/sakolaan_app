// lib/screens/siswa/siswa_tambah_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/siswa_model.dart';
import '../../models/kelas_model.dart';
import '../../providers/siswa_provider.dart';
import '../../services/kelas_service.dart';

class SiswaTambahPage extends ConsumerStatefulWidget {
  const SiswaTambahPage({super.key});

  @override
  ConsumerState<SiswaTambahPage> createState() => _SiswaTambahPageState();
}

class _SiswaTambahPageState extends ConsumerState<SiswaTambahPage> {
  final _formKey = GlobalKey<FormState>();
  final nisController = TextEditingController();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final noHpController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingKelas = false;
  
  // ✅ TAMBAHAN: Untuk dropdown kelas
  List<Kelas> _kelasList = [];
  String? _selectedKelasId;
  String? _selectedJenisKelamin;

  @override
  void initState() {
    super.initState();
    _loadKelas();
  }

  @override
  void dispose() {
    nisController.dispose();
    namaController.dispose();
    alamatController.dispose();
    noHpController.dispose();
    super.dispose();
  }

  // ✅ TAMBAHAN: Load data kelas dari API
  Future<void> _loadKelas() async {
    setState(() => _isLoadingKelas = true);
    try {
      final kelas = await KelasService.getKelas();
      setState(() {
        _kelasList = kelas;
        _isLoadingKelas = false;
      });
    } catch (e) {
      setState(() => _isLoadingKelas = false);
      _showMessage('Gagal memuat data kelas', isError: true);
    }
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

  Future<void> _saveSiswa() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ✅ Validasi kelas harus dipilih
    if (_selectedKelasId == null) {
      _showMessage('Silakan pilih kelas', isError: true);
      return;
    }

    // ✅ Validasi jenis kelamin harus dipilih
    if (_selectedJenisKelamin == null) {
      _showMessage('Silakan pilih jenis kelamin', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final newSiswa = Siswa(
      nis: nisController.text.trim(),
      nama: namaController.text.trim(),
      kelasId: _selectedKelasId!, // ✅ Gunakan kelas_id
      jenisKelamin: _selectedJenisKelamin!,
      alamat: alamatController.text.trim(),
      noHp: noHpController.text.trim(),
    );

    final siswaNotifier = ref.read(siswaProvider.notifier);
    final success = await siswaNotifier.createSiswa(newSiswa);

    setState(() => _isLoading = false);

    if (success) {
      _showMessage('Data berhasil ditambahkan');
      if (mounted) {
        context.pop();
      }
    } else {
      _showMessage('Gagal menambahkan data', isError: true);
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
            child: isMobile ? _buildMobileHeader() : _buildDesktopHeader(),
          ),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 20 : 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Form(
                      key: _formKey,
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
                          
                          // NIS
                          TextFormField(
                            controller: nisController,
                            decoration: InputDecoration(
                              labelText: 'NIS',
                              hintText: 'Masukkan NIS',
                              prefixIcon: const Icon(Icons.badge),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'NIS harus diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Nama Lengkap
                          TextFormField(
                            controller: namaController,
                            decoration: InputDecoration(
                              labelText: 'Nama Lengkap',
                              hintText: 'Masukkan nama lengkap',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama harus diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // ✅ DROPDOWN KELAS
                          DropdownButtonFormField<String>(
                            value: _selectedKelasId,
                            decoration: InputDecoration(
                              labelText: 'Kelas',
                              hintText: 'Pilih kelas',
                              prefixIcon: const Icon(Icons.school),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            items: _isLoadingKelas
                                ? []
                                : _kelasList.map((kelas) {
                                    return DropdownMenuItem<String>(
                                      value: kelas.id,
                                      child: Text('${kelas.namaKelas} - ${kelas.jurusan}'),
                                    );
                                  }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedKelasId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kelas harus dipilih';
                              }
                              return null;
                            },
                          ),
                          if (_isLoadingKelas)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'Memuat data kelas...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          
                          // ✅ DROPDOWN JENIS KELAMIN
                          DropdownButtonFormField<String>(
                            value: _selectedJenisKelamin,
                            decoration: InputDecoration(
                              labelText: 'Jenis Kelamin',
                              hintText: 'Pilih jenis kelamin',
                              prefixIcon: const Icon(Icons.people),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'L',
                                child: Text('Laki-laki'),
                              ),
                              DropdownMenuItem(
                                value: 'P',
                                child: Text('Perempuan'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedJenisKelamin = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Jenis kelamin harus dipilih';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Alamat
                          TextFormField(
                            controller: alamatController,
                            decoration: InputDecoration(
                              labelText: 'Alamat',
                              hintText: 'Masukkan alamat lengkap',
                              prefixIcon: const Icon(Icons.home),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Alamat harus diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // No HP
                          TextFormField(
                            controller: noHpController,
                            decoration: InputDecoration(
                              labelText: 'No HP',
                              hintText: 'Masukkan nomor HP',
                              prefixIcon: const Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'No HP harus diisi';
                              }
                              return null;
                            },
                          ),
                          
                          // Mobile buttons (shown at bottom on mobile)
                          if (isMobile) ...[
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _isLoading ? null : () => context.pop(),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Batal'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _saveSiswa,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade600,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : const Text('Simpan'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
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

  Widget _buildDesktopHeader() {
    return Row(
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
            Icons.person_add,
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
                'Tambah Siswa Baru',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Masukkan informasi data siswa baru',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: _isLoading ? null : () => context.go('/siswa'),
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
          onPressed: _isLoading ? null : _saveSiswa,
          icon: _isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.save, size: 18),
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
    );
  }

  Widget _buildMobileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.go('/siswa'),
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Kembali',
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.person_add,
                color: Colors.green.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Tambah Siswa Baru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(left: 56),
          child: Text(
            'Masukkan informasi data siswa baru',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}