import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/services/kelas_service.dart';

class KelasTambahPage extends StatefulWidget {
  const KelasTambahPage({super.key});

  @override
  State<KelasTambahPage> createState() => _KelasTambahPageState();
}

class _KelasTambahPageState extends State<KelasTambahPage> {
  final _formKey = GlobalKey<FormState>();

  final _kelasController = TextEditingController();
  final _tingkatController = TextEditingController();
  final _jurusanController = TextEditingController();
  final _waliController = TextEditingController();
  final _kapasitasController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _kelasController.dispose();
    _tingkatController.dispose();
    _jurusanController.dispose();
    _waliController.dispose();
    _kapasitasController.dispose();
    super.dispose();
  }

  // Submit ke API
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final success = await KelasService.tambahKelas(
          namaKelas: _kelasController.text,
          tingkat: _tingkatController.text,
          jurusan: _jurusanController.text,
          waliKelas: _waliController.text.isEmpty ? null : _waliController.text,
          kapasitas: int.tryParse(_kapasitasController.text),
        );

        setState(() => _isLoading = false);

        if (!mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kelas berhasil ditambahkan'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menambahkan kelas. Silakan coba lagi.'),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      // ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _isLoading ? null : () => context.pop(),
        ),
        title: const Row(
          children: [
            Icon(Icons.class_, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Tambah Kelas Baru',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ================= INFO CARD =================
                      Card(
                        elevation: 2,
                        shadowColor: Colors.green.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Informasi Kelas',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Nama Kelas
                              _buildField(
                                controller: _kelasController,
                                label: 'Nama Kelas',
                                hint: 'Contoh: X IPA 1',
                                icon: Icons.class_,
                                enabled: !_isLoading,
                                validator: (v) =>
                                    v!.isEmpty ? 'Nama kelas wajib diisi' : null,
                              ),
                              const SizedBox(height: 16),

                              // Row Tingkat & Jurusan
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildField(
                                      controller: _tingkatController,
                                      label: 'Tingkat',
                                      hint: 'X, XI, XII',
                                      icon: Icons.stairs,
                                      enabled: !_isLoading,
                                      validator: (v) =>
                                          v!.isEmpty ? 'Wajib diisi' : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildField(
                                      controller: _jurusanController,
                                      label: 'Jurusan',
                                      hint: 'IPA, IPS, TKJ',
                                      icon: Icons.school_outlined,
                                      enabled: !_isLoading,
                                      validator: (v) =>
                                          v!.isEmpty ? 'Wajib diisi' : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Wali Kelas
                              _buildField(
                                controller: _waliController,
                                label: 'Wali Kelas',
                                hint: 'Nama wali kelas (opsional)',
                                icon: Icons.person,
                                enabled: !_isLoading,
                              ),
                              const SizedBox(height: 16),

                              // Kapasitas
                              _buildField(
                                controller: _kapasitasController,
                                label: 'Kapasitas Siswa',
                                hint: 'Contoh: 32 (opsional)',
                                icon: Icons.groups,
                                keyboardType: TextInputType.number,
                                enabled: !_isLoading,
                                validator: (v) {
                                  if (v != null && v.isNotEmpty) {
                                    if (int.tryParse(v) == null || int.parse(v) <= 0) {
                                      return 'Kapasitas harus lebih dari 0';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ================= INFO NOTE =================
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Siswa dapat ditambahkan ke kelas ini setelah kelas berhasil dibuat.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ================= BUTTON SIMPAN =================
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _submit,
                          icon: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.save, color: Colors.white),
                          label: Text(
                            _isLoading ? 'Menyimpan...' : 'Simpan Kelas',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            disabledBackgroundColor: Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ================= BUTTON BATAL =================
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : () => context.pop(),
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ================= LOADING OVERLAY =================
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(100),
              child: Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.green.shade600,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Menyimpan data kelas...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

  // ================= INPUT FIELD =================
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
        prefixIcon: Icon(icon, color: Colors.green.shade600),
        filled: true,
        fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}