import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/pengumuman_model.dart';
import '../providers/pengumuman_provider.dart';
import '../utils/date_formatter.dart';

class PengumumanScreen extends ConsumerStatefulWidget {
  const PengumumanScreen({super.key});

  @override
  ConsumerState<PengumumanScreen> createState() => _PengumumanScreenState();
}

class _PengumumanScreenState extends ConsumerState<PengumumanScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pengumumanState = ref.watch(pengumumanProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 6,
        backgroundColor: Colors.grey.shade100,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            Icon(Icons.campaign_outlined, color: Colors.green.shade600, size: isMobile ? 24 : 28),
            const SizedBox(width: 12),
            Text(
              'Pengumuman',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
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
            padding: EdgeInsets.all(isMobile ? 20 : 32),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengumuman Sekolah',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Informasi terbaru untuk siswa dan guru',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Search and Filter Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 32,
              0,
              isMobile ? 16 : 32,
              isMobile ? 16 : 24,
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari pengumuman...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(pengumumanProvider.notifier).setSearchQuery('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade50,
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: (value) {
                    ref.read(pengumumanProvider.notifier).setSearchQuery(value);
                  },
                ),
                const SizedBox(height: 16),

                // Category Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('semua', 'Semua', Icons.all_inclusive),
                      const SizedBox(width: 8),
                      _buildFilterChip('penting', 'Penting', Icons.priority_high),
                      const SizedBox(width: 8),
                      _buildFilterChip('kegiatan', 'Kegiatan', Icons.event),
                      const SizedBox(width: 8),
                      _buildFilterChip('umum', 'Umum', Icons.info_outline),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: pengumumanState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : pengumumanState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                            const SizedBox(height: 16),
                            Text(
                              'Terjadi kesalahan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pengumumanState.error!,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => ref.read(pengumumanProvider.notifier).loadPengumuman(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Coba Lagi'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : pengumumanState.filteredPengumuman.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.campaign_outlined, size: 64, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada pengumuman',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Belum ada pengumuman yang tersedia',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => ref.read(pengumumanProvider.notifier).loadPengumuman(),
                            child: ListView.builder(
                              padding: EdgeInsets.all(isMobile ? 16 : 32),
                              itemCount: pengumumanState.filteredPengumuman.length,
                              itemBuilder: (context, index) {
                                final pengumuman = pengumumanState.filteredPengumuman[index];
                                return _buildPengumumanCard(context, pengumuman, isMobile);
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTambahPengumumanDialog(context),
        backgroundColor: Colors.green.shade600,
        icon: const Icon(Icons.add),
        label: Text(isMobile ? 'Tambah' : 'Tambah Pengumuman'),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final pengumumanState = ref.watch(pengumumanProvider);
    final isSelected = pengumumanState.selectedKategori == value;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selectedColor: Colors.green.shade600,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(
        color: isSelected ? Colors.green.shade600 : Colors.grey.shade300,
      ),
      onSelected: (selected) {
        ref.read(pengumumanProvider.notifier).setKategori(value);
      },
    );
  }

  Widget _buildPengumumanCard(BuildContext context, Pengumuman pengumuman, bool isMobile) {
    final kategoriColor = _getKategoriColor(pengumuman.kategori);

    return Card(
      margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: pengumuman.isPinned ? Colors.green.shade600 : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _showDetailDialog(context, pengumuman),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with badge and pin
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kategoriColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: kategoriColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getKategoriIcon(pengumuman.kategori),
                          size: 14,
                          color: kategoriColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getKategoriLabel(pengumuman.kategori),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: kategoriColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (pengumuman.isPinned) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.green.shade600.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.push_pin,
                            size: 14,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Disematkan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'pin',
                        child: Row(
                          children: [
                            Icon(
                              pengumuman.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(pengumuman.isPinned ? 'Lepas Pin' : 'Sematkan'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 18, color: Colors.red),
                            const SizedBox(width: 12),
                            Text('Hapus', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'pin') {
                        ref.read(pengumumanProvider.notifier).togglePin(pengumuman.id);
                      } else if (value == 'edit') {
                        _showEditPengumumanDialog(context, pengumuman);
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(context, pengumuman);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                pengumuman.judul,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Content preview
              Text(
                pengumuman.isi,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Footer
              Row(
                children: [
                  Icon(Icons.person_outline, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    pengumuman.penulis ?? 'Admin',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      DateFormatter.formatIndonesian(pengumuman.tanggal),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getKategoriColor(String kategori) {
    switch (kategori) {
      case 'penting':
        return Colors.red.shade600;
      case 'kegiatan':
        return Colors.blue.shade600;
      case 'umum':
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getKategoriIcon(String kategori) {
    switch (kategori) {
      case 'penting':
        return Icons.priority_high;
      case 'kegiatan':
        return Icons.event;
      case 'umum':
      default:
        return Icons.info_outline;
    }
  }

  String _getKategoriLabel(String kategori) {
    switch (kategori) {
      case 'penting':
        return 'PENTING';
      case 'kegiatan':
        return 'KEGIATAN';
      case 'umum':
      default:
        return 'UMUM';
    }
  }

  void _showDetailDialog(BuildContext context, Pengumuman pengumuman) {
    final kategoriColor = _getKategoriColor(pengumuman.kategori);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kategoriColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: kategoriColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getKategoriIcon(pengumuman.kategori),
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _getKategoriLabel(pengumuman.kategori),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pengumuman.judul,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pengumuman.isi,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 18, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            pengumuman.penulis ?? 'Admin',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            DateFormatter.formatIndonesian(pengumuman.tanggal),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTambahPengumumanDialog(BuildContext context) {
    final judulController = TextEditingController();
    final isiController = TextEditingController();
    String kategori = 'umum';
    bool isPinned = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Tambah Pengumuman'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: judulController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: isiController,
                  decoration: InputDecoration(
                    labelText: 'Isi Pengumuman',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: kategori,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'umum', child: Text('Umum')),
                    DropdownMenuItem(value: 'penting', child: Text('Penting')),
                    DropdownMenuItem(value: 'kegiatan', child: Text('Kegiatan')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => kategori = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: isPinned,
                  onChanged: (value) {
                    setState(() => isPinned = value ?? false);
                  },
                  title: const Text('Sematkan pengumuman'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (judulController.text.isNotEmpty && isiController.text.isNotEmpty) {
                  final pengumuman = Pengumuman(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    judul: judulController.text,
                    isi: isiController.text,
                    kategori: kategori,
                    tanggal: DateTime.now(),
                    penulis: 'Admin',
                    isPinned: isPinned,
                  );
                  
                  ref.read(pengumumanProvider.notifier).tambahPengumuman(pengumuman);
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pengumuman berhasil ditambahkan')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPengumumanDialog(BuildContext context, Pengumuman pengumuman) {
    final judulController = TextEditingController(text: pengumuman.judul);
    final isiController = TextEditingController(text: pengumuman.isi);
    String kategori = pengumuman.kategori;
    bool isPinned = pengumuman.isPinned;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Edit Pengumuman'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: judulController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: isiController,
                  decoration: InputDecoration(
                    labelText: 'Isi Pengumuman',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: kategori,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'umum', child: Text('Umum')),
                    DropdownMenuItem(value: 'penting', child: Text('Penting')),
                    DropdownMenuItem(value: 'kegiatan', child: Text('Kegiatan')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => kategori = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: isPinned,
                  onChanged: (value) {
                    setState(() => isPinned = value ?? false);
                  },
                  title: const Text('Sematkan pengumuman'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (judulController.text.isNotEmpty && isiController.text.isNotEmpty) {
                  final updated = pengumuman.copyWith(
                    judul: judulController.text,
                    isi: isiController.text,
                    kategori: kategori,
                    isPinned: isPinned,
                  );
                  
                  ref.read(pengumumanProvider.notifier).updatePengumuman(updated);
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pengumuman berhasil diperbarui')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Pengumuman pengumuman) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Pengumuman'),
        content: Text('Apakah Anda yakin ingin menghapus "${pengumuman.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(pengumumanProvider.notifier).hapusPengumuman(pengumuman.id);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pengumuman berhasil dihapus')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}