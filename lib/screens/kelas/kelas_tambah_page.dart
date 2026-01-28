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
  final _tingkatController = TextEditingController(); // ✅ TAMBAH INI
  final _jurusanController = TextEditingController(); // ✅ TAMBAH INI
  final _waliController = TextEditingController();
  final _kapasitasController = TextEditingController(); // ✅ TAMBAH INI (opsional)

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

  // ================= SUBMIT KE API =================
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // ✅ PERBAIKAN: Kirim data sesuai parameter yang ada di KelasService
        final success = await KelasService.tambahKelas(
          namaKelas: _kelasController.text,
          tingkat: _tingkatController.text,      // ✅ WAJIB
          jurusan: _jurusanController.text,      // ✅ WAJIB
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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      // ================= APPBAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green.shade700),
          onPressed: _isLoading ? null : () => context.pop(),
        ),
        title: Row(
          children: [
            Icon(Icons.school, color: Colors.green.shade600),
            const SizedBox(width: 10),
            const Text(
              'Tambah Kelas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= INFO KELAS =================
                  _card(
                    title: 'Informasi Kelas',
                    child: Column(
                      children: [
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
                        
                        // ✅ TAMBAH FIELD TINGKAT
                        _buildField(
                          controller: _tingkatController,
                          label: 'Tingkat',
                          hint: 'Contoh: X, XI, XII',
                          icon: Icons.stairs,
                          enabled: !_isLoading,
                          validator: (v) =>
                              v!.isEmpty ? 'Tingkat wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),
                        
                        // ✅ TAMBAH FIELD JURUSAN
                        _buildField(
                          controller: _jurusanController,
                          label: 'Jurusan',
                          hint: 'Contoh: IPA, IPS, TKJ',
                          icon: Icons.school_outlined,
                          enabled: !_isLoading,
                          validator: (v) =>
                              v!.isEmpty ? 'Jurusan wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildField(
                          controller: _waliController,
                          label: 'Wali Kelas (Opsional)',
                          hint: 'Contoh: Bapak Andi',
                          icon: Icons.person,
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 16),
                        
                        // ✅ TAMBAH FIELD KAPASITAS
                        _buildField(
                          controller: _kapasitasController,
                          label: 'Kapasitas (Opsional)',
                          hint: 'Contoh: 32',
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

                  const SizedBox(height: 32),

                  // ================= BUTTON =================
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
                              'Simpan Kelas',
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

          // ================= LOADING OVERLAY =================
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

  // ================= CARD =================
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

  // ================= INPUT =================
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
      onChanged: onChanged,
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