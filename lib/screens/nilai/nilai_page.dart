// lib/screens/nilai/nilai_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NilaiPage extends ConsumerStatefulWidget {
  const NilaiPage({super.key});

  @override
  ConsumerState<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends ConsumerState<NilaiPage> {
  String _searchQuery = '';
  String _filterKelas = 'Semua';
  String _filterMapel = 'Semua';

  // Dummy data - ganti dengan data dari provider nanti
  final List<Map<String, dynamic>> _dummyNilai = [
    {
      'id': 1,
      'nama': 'Ahmad Fauzi',
      'nis': '2024001',
      'kelas': 'X IPA 1',
      'mapel': 'Matematika',
      'nilai': 85,
      'kategori': 'UTS',
    },
    {
      'id': 2,
      'nama': 'Siti Nurhaliza',
      'nis': '2024002',
      'kelas': 'X IPA 1',
      'mapel': 'Fisika',
      'nilai': 90,
      'kategori': 'UAS',
    },
    {
      'id': 3,
      'nama': 'Budi Santoso',
      'nis': '2024003',
      'kelas': 'X IPS 1',
      'mapel': 'Ekonomi',
      'nilai': 78,
      'kategori': 'UTS',
    },
    {
      'id': 4,
      'nama': 'Dewi Lestari',
      'nis': '2024004',
      'kelas': 'X IPA 2',
      'mapel': 'Biologi',
      'nilai': 92,
      'kategori': 'UAS',
    },
    {
      'id': 5,
      'nama': 'Rudi Hermawan',
      'nis': '2024005',
      'kelas': 'X IPS 1',
      'mapel': 'Sejarah',
      'nilai': 82,
      'kategori': 'UTS',
    },
  ];

  List<Map<String, dynamic>> get _filteredList {
    return _dummyNilai.where((nilai) {
      final matchSearch = nilai['nama'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          nilai['nis'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          nilai['mapel'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchKelas = _filterKelas == 'Semua' || nilai['kelas'] == _filterKelas;
      final matchMapel = _filterMapel == 'Semua' || nilai['mapel'] == _filterMapel;
      
      return matchSearch && matchKelas && matchMapel;
    }).toList();
  }

  Color _getNilaiColor(int nilai) {
    if (nilai >= 85) return Colors.green;
    if (nilai >= 70) return Colors.orange;
    return Colors.red;
  }

  String _getNilaiGrade(int nilai) {
    if (nilai >= 85) return 'A';
    if (nilai >= 70) return 'B';
    if (nilai >= 60) return 'C';
    if (nilai >= 50) return 'D';
    return 'E';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 6,
        backgroundColor: Colors.grey.shade100,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green.shade700),
          onPressed: () => context.go('/home'),
        ),
        title: Row(
          children: [
            Icon(Icons.assignment, color: Colors.green.shade600, size: isMobile ? 24 : 28),
            const SizedBox(width: 12),
            Text(
              'Data Nilai',
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMobile)
                  const Text(
                    'Kelola data nilai siswa',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                SizedBox(height: isMobile ? 12 : 16),
                
                // Search & Filters
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    // Search Bar
                    Container(
                      width: isMobile ? double.infinity : (isTablet ? 300 : 400),
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: (value) => setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          hintText: 'Cari nilai...',
                          hintStyle: TextStyle(fontSize: isMobile ? 14 : 15),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    
                    // Filter Kelas
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _filterKelas,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                          items: ['Semua', 'X IPA 1', 'X IPA 2', 'X IPS 1']
                              .map((kelas) => DropdownMenuItem(
                                    value: kelas,
                                    child: Text(kelas),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _filterKelas = value!),
                        ),
                      ),
                    ),
                    
                    // Filter Mapel
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _filterMapel,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                          items: ['Semua', 'Matematika', 'Fisika', 'Biologi', 'Ekonomi', 'Sejarah']
                              .map((mapel) => DropdownMenuItem(
                                    value: mapel,
                                    child: Text(mapel),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _filterMapel = value!),
                        ),
                      ),
                    ),
                    
                    // Add Button
                    SizedBox(
                      width: isMobile ? double.infinity : null,
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/nilai/tambah'),
                        icon: const Icon(Icons.add, size: 20),
                        label: Text(isMobile ? 'Tambah' : 'Tambah Nilai'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content Section
          Expanded(
            child: _filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text(
                          'Tidak ada hasil',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Coba kata kunci pencarian yang lain',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      // Implement refresh logic
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: isMobile
                        ? _buildMobileList(_filteredList)
                        : _buildDesktopTable(_filteredList, isTablet),
                  ),
          ),
        ],
      ),
    );
  }

  // Mobile List View
  Widget _buildMobileList(List<Map<String, dynamic>> filteredList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final nilai = filteredList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: InkWell(
            onTap: () => context.push('/nilai/${nilai['id']}'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _getNilaiColor(nilai['nilai']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            _getNilaiGrade(nilai['nilai']),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _getNilaiColor(nilai['nilai']),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nilai['nama'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${nilai['nis']} • ${nilai['kelas']}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        nilai['nilai'].toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getNilaiColor(nilai['nilai']),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.book_outlined, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        nilai['mapel'],
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          nilai['kategori'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Desktop Table View
  Widget _buildDesktopTable(List<Map<String, dynamic>> filteredList, bool isTablet) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet ? 16 : 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Nilai',
                      _dummyNilai.length.toString(),
                      Icons.assignment_outlined,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Rata-rata',
                      (_dummyNilai.map((e) => e['nilai'] as int).reduce((a, b) => a + b) / _dummyNilai.length)
                          .toStringAsFixed(1),
                      Icons.trending_up,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Hasil Pencarian',
                      _filteredList.length.toString(),
                      Icons.search,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Table
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 60),
                          _buildTableHeader('Nama Siswa', flex: 3),
                          _buildTableHeader('NIS', flex: 2),
                          _buildTableHeader('Kelas', flex: 2),
                          _buildTableHeader('Mata Pelajaran', flex: 2),
                          _buildTableHeader('Kategori', flex: 2),
                          _buildTableHeader('Nilai', flex: 1),
                          _buildTableHeader('Grade', flex: 1),
                          const SizedBox(width: 100),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Table Body
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final nilai = filteredList[index];
                        return InkWell(
                          onTap: () => context.push('/nilai/${nilai['id']}'),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: _getNilaiColor(nilai['nilai']).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getNilaiGrade(nilai['nilai']),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: _getNilaiColor(nilai['nilai']),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _buildTableCell(nilai['nama'], flex: 3, bold: true),
                                _buildTableCell(nilai['nis'], flex: 2),
                                _buildTableCell(nilai['kelas'], flex: 2),
                                _buildTableCell(nilai['mapel'], flex: 2),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      nilai['kategori'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue.shade700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                _buildTableCell(
                                  nilai['nilai'].toString(),
                                  flex: 1,
                                  bold: true,
                                  color: _getNilaiColor(nilai['nilai']),
                                ),
                                _buildTableCell(
                                  _getNilaiGrade(nilai['nilai']),
                                  flex: 1,
                                  bold: true,
                                  color: _getNilaiColor(nilai['nilai']),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () => context.push('/nilai/${nilai['id']}'),
                                        icon: Icon(Icons.edit_outlined, color: Colors.blue.shade600),
                                        tooltip: 'Edit',
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Delete confirmation
                                        },
                                        icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                                        tooltip: 'Hapus',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text, {int flex = 1}) {
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

  Widget _buildTableCell(String text, {int flex = 1, bool bold = false, Color? color}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          color: color ?? (bold ? Colors.black87 : Colors.grey.shade700),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}