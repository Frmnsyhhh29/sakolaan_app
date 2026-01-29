// lib/screens/mapel/mapel_tambah_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/mapel_service.dart';

class MapelTambahPage extends StatefulWidget {
  const MapelTambahPage({super.key});

  @override
  State<MapelTambahPage> createState() => _MapelTambahPageState();
}

class _MapelTambahPageState extends State<MapelTambahPage> {
  final _formKey = GlobalKey<FormState>();

  final _kodeMapelController = TextEditingController();
  final _namaMapelController = TextEditingController();
  final _guruPengampuController = TextEditingController();
  final _jamPelajaranController = TextEditingController();
  final _deskripsiController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _kodeMapelController.dispose();
    _namaMapelController.dispose();
    _guruPengampuController.dispose();
    _jamPelajaranController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final success = await MapelService.tambahMapel(
          kodeMapel: _kodeMapelController.text,
          namaMapel: _namaMapelController.text,
          guruPengampu: _guruPengampuController.text,
          jamPelajaran: int.parse(_jamPelajaranController.text),
          deskripsi: _deskripsiController.text.isEmpty 
              ? null 
              : _deskripsiController.text,
        );

        setState(() => _isLoading = false);

        if (!mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mata pelajaran berhasil ditambahkan'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          context.pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menambahkan mata pelajaran'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green.shade700),
          onPressed: _isLoading ? null : () => context.pop(),
        ),
        title: Row(
          children: [
            Icon(Icons.menu_book, color: Colors.green.shade600),
            const SizedBox(width: 10),
            const Text(
              'Tambah Mata Pelajaran',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _card(
                    title: 'Informasi Mata Pelajaran',
                    child: Column(
                      children: [
                        // KODE MAPEL
                        _buildField(
                          controller: _kodeMapelController,
                          label: 'Kode Mata Pelajaran',
                          hint: 'Contoh: MAT101',
                          icon: Icons.code,
                          enabled: !_isLoading,
                          validator: (v) =>
                              v!.isEmpty ? 'Kode mapel wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),

                        // NAMA MAPEL
                        _buildField(
                          controller: _namaMapelController,
                          label: 'Nama Mata Pelajaran',
                          hint: 'Contoh: Matematika',
                          icon: Icons.menu_book,
                          enabled: !_isLoading,
                          validator: (v) =>
                              v!.isEmpty ? 'Nama mapel wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),

                        // GURU PENGAMPU
                        _buildField(
                          controller: _guruPengampuController,
                          label: 'Guru Pengampu',
                          hint: 'Contoh: Bapak Ahmad',
                          icon: Icons.person,
                          enabled: !_isLoading,
                          validator: (v) =>
                              v!.isEmpty ? 'Guru pengampu wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),

                        // JAM PELAJARAN
                        _buildField(
                          controller: _jamPelajaranController,
                          label: 'Jam Pelajaran per Minggu',
                          hint: 'Contoh: 4',
                          icon: Icons.schedule,
                          keyboardType: TextInputType.number,
                          enabled: !_isLoading,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'Jam pelajaran wajib diisi';
                            }
                            if (int.tryParse(v) == null || int.parse(v) <= 0) {
                              return 'Jam pelajaran harus lebih dari 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // DESKRIPSI
                        TextFormField(
                          controller: _deskripsiController,
                          enabled: !_isLoading,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Deskripsi (Opsional)',
                            hintText: 'Contoh: Mata pelajaran wajib untuk kelas X',
                            prefixIcon: const Icon(Icons.description),
                            filled: true,
                            fillColor: _isLoading
                                ? Colors.grey.shade200
                                : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // BUTTON SIMPAN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        disabledBackgroundColor: Colors.grey.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Simpan Mata Pelajaran',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // LOADING OVERLAY
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(76),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Menyimpan data...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: enabled ? Colors.grey.shade100 : Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}