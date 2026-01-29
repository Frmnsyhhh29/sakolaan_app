// lib/screens/mapel/mapel_edit_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MapelEditPage extends StatefulWidget {
  final String mapelId;

  const MapelEditPage({
    super.key,
    required this.mapelId,
  });

  @override
  State<MapelEditPage> createState() => _MapelEditPageState();
}

class _MapelEditPageState extends State<MapelEditPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _kodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // TODO: ganti dengan data dari API
    _namaController.text = 'Matematika';
    _kodeController.text = 'MTK';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kodeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: kirim update ke API

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mapel berhasil diperbarui')),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Mata Pelajaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mapel',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kodeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Mapel',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
