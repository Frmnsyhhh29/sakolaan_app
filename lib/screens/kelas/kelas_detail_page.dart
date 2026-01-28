// lib/screens/kelas/kelas_detail_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/siswa_model.dart';
import '../../services/kelas_service.dart';

class KelasDetailPage extends StatefulWidget {
  final String kelasId;

  const KelasDetailPage({
    super.key,
    required this.kelasId,
  });

  @override
  State<KelasDetailPage> createState() => _KelasDetailPageState();
}

class _KelasDetailPageState extends State<KelasDetailPage> {
  String _searchQuery = '';
  late Future<Map<String, dynamic>> _detailFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _detailFuture = KelasService.getKelasDetail(widget.kelasId);
  }

  List<Siswa> _filterSiswa(List<Siswa> siswaList) {
    if (_searchQuery.isEmpty) return siswaList;
    
    return siswaList.where((siswa) {
      return siswa.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             siswa.nis.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 900;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Icon(Icons.class_, color: Colors.green.shade600),
            const SizedBox(width: 12),
            FutureBuilder<Map<String, dynamic>>(
              future: _detailFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!['namaKelas'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                }
                return const Text('Loading...');
              },
            ),
          ],
        ),
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailFuture,
        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ERROR
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi kesalahan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _loadData()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // DATA
          final data = snapshot.data!;
          final waliKelas = data['waliKelas'] ?? '';
          final siswaList = data['siswa'] as List<Siswa>;
          final filteredSiswa = _filterSiswa(siswaList);

          return Column(
            children: [
              // ================= INFO CARD =================
              Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      _infoItem(
                        Icons.person_outline,
                        'Wali Kelas',
                        waliKelas,
                      ),
                      _infoItem(
                        Icons.people_outline,
                        'Jumlah Siswa',
                        siswaList.length.toString(),
                      ),
                      SizedBox(
                        width: isMobile ? double.infinity : 300,
                        child: TextField(
                          onChanged: (v) => setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'Cari siswa (nama / NIS)',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ================= CONTENT =================
              Expanded(
                child: filteredSiswa.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Belum ada siswa di kelas ini'
                                  : 'Siswa tidak ditemukan',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : isMobile
                        ? _buildMobileList(filteredSiswa)
                        : _buildDesktopTable(filteredSiswa, isTablet),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= MOBILE LIST =================
  Widget _buildMobileList(List<Siswa> siswaList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: siswaList.length,
      itemBuilder: (context, index) {
        final siswa = siswaList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan avatar
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      radius: 24,
                      child: Text(
                        siswa.nama[0].toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            siswa.nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NIS: ${siswa.nis}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const Divider(height: 24),
                
                // Detail informasi
                _mobileInfoRow(Icons.home_outlined, 'Alamat', siswa.alamat),
                const SizedBox(height: 8),
                _mobileInfoRow(Icons.phone_outlined, 'No HP', siswa.noHp),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _mobileInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
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
    );
  }

  // ================= DESKTOP TABLE =================
  Widget _buildDesktopTable(List<Siswa> siswaList, bool isTablet) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 16 : 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    children: [
                      _tableHeader('No', flex: 1),
                      _tableHeader('NIS', flex: 2),
                      _tableHeader('Nama', flex: 3),
                      _tableHeader('Alamat', flex: 3),
                      _tableHeader('No HP', flex: 2),
                    ],
                  ),
                ),
                const Divider(height: 1),
                
                // Body
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: siswaList.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final siswa = siswaList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          _tableCell('${index + 1}', flex: 1),
                          _tableCell(siswa.nis, flex: 2),
                          _tableCell(siswa.nama, flex: 3, bold: true),
                          _tableCell(siswa.alamat, flex: 3),
                          _tableCell(siswa.noHp, flex: 2),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= COMPONENTS =================
  Widget _infoItem(IconData icon, String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: Colors.green.shade600),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tableHeader(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _tableCell(String text, {int flex = 1, bool bold = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          fontSize: 14,
          color: bold ? Colors.black87 : Colors.grey.shade700,
        ),
      ),
    );
  }
}