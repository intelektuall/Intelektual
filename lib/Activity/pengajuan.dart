import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/hewan_provider.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  @override
  State<SubmissionHistoryScreen> createState() => _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final provider = Provider.of<HewanProvider>(context, listen: false);
    await provider.loadSubmissions(); // Ganti dari _loadSubmissions ke loadSubmissions
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HewanProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Riwayat Pengajuan',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              await _showUpdateConfirmation(context);
            },
            tooltip: 'Update Data',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder(
          future: _initializeData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                if (provider.pendingSubmissions.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    color: Colors.orange[100],
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange[800]),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${provider.pendingSubmissions.length} pengajuan menunggu update',
                            style: TextStyle(color: Colors.orange[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                _buildLastUpdateInfo(provider),
                _buildStatsInfo(provider),
                Expanded(child: _buildSubmissionsList(provider)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        child: Icon(Icons.refresh),
        tooltip: 'Refresh Data',
      ),
    );
  }

  Future<void> _initializeData(BuildContext context) async {
    final provider = Provider.of<HewanProvider>(context, listen: false);
    // Data sudah di-load oleh provider di constructor
  }

  Widget _buildLastUpdateInfo(HewanProvider provider) {
    return FutureBuilder<DateTime?>(
      future: provider.getLastUpdateTime(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            color: Colors.grey[100],
            child: Text(
              'Terakhir update: ${_formatDate(snapshot.data!)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  Widget _buildStatsInfo(HewanProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      color: Colors.blue[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', provider.submissions.length.toString()),
          _buildStatItem('Pending', provider.pendingSubmissions.length.toString()),
          _buildStatItem('Disetujui', 
            provider.submissions.where((s) => s['status'] == 'Approved').length.toString()),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[800]),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSubmissionsList(HewanProvider provider) {
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final submissions = provider.submissions;

    if (submissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Belum ada riwayat pengajuan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Ajukan hewan baru melalui menu "Ajukan Hewan"',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: submissions.length,
      itemBuilder: (context, index) {
        final submission = submissions[index];
        return _buildSubmissionCard(context, submission, provider);
      },
    );
  }

  Widget _buildSubmissionCard(BuildContext context, Map<String, dynamic> submission, HewanProvider provider) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          Icons.pets,
          color: _getStatusColor(submission['status']),
        ),
        title: Text(
          submission['name'] ?? 'No Name',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  submission['status'] ?? 'No Status',
                  style: TextStyle(
                    color: _getStatusColor(submission['status']),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!(submission['isSynced'] ?? true))
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'BARU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              'Jenis: ${submission['type']}',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'Lokasi: ${submission['location']}',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              'Diajukan: ${_formatDate(submission['timestamp'])}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, submission, provider),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 20),
                  SizedBox(width: 8),
                  Text('Lihat Detail'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Hapus', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showSubmissionDetails(context, submission),
      ),
    );
  }

  void _handleMenuAction(String action, Map<String, dynamic> submission, HewanProvider provider) {
    final id = submission['id'];
    if (id == null) return;

    switch (action) {
      case 'view':
        _showSubmissionDetails(context, submission);
        break;
      case 'edit':
        _showEditDialog(context, submission, provider);
        break;
      case 'delete':
        _showDeleteConfirmation(context, id, provider);
        break;
    }
  }

  void _showSubmissionDetails(BuildContext context, Map<String, dynamic> submission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Pengajuan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Nama', submission['name']),
              _buildDetailRow('Jenis', submission['type']),
              _buildDetailRow('Lokasi', submission['location']),
              _buildDetailRow('Perkiraan Jumlah', submission['count']),
              _buildDetailRow('Deskripsi', submission['desc']),
              _buildDetailRow('Status', submission['status']),
              _buildDetailRow('Tanggal Pengajuan', _formatDate(submission['timestamp'])),
              if (submission['image'] != null && submission['image'].isNotEmpty)
                _buildDetailRow('Foto', 'Tersedia'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> submission, HewanProvider provider) {
    final nameController = TextEditingController(text: submission['name']);
    final countController = TextEditingController(text: submission['count']);
    final descController = TextEditingController(text: submission['desc']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Pengajuan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Hewan'),
              ),
              TextField(
                controller: countController,
                decoration: InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final updatedSubmission = {
                ...submission,
                'name': nameController.text,
                'count': countController.text,
                'desc': descController.text,
                'timestamp': DateTime.now(),
              };
              
              await provider.updateSubmission(submission['id'], updatedSubmission);
              Navigator.pop(context);
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int id, HewanProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Pengajuan'),
        content: Text('Apakah Anda yakin ingin menghapus pengajuan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteSubmission(id);
              Navigator.pop(context);
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _showUpdateConfirmation(BuildContext context) async {
    final provider = Provider.of<HewanProvider>(context, listen: false);
    
    if (provider.pendingSubmissions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada data baru untuk diupdate')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Data'),
        content: Text(
            'Ada ${provider.pendingSubmissions.length} pengajuan baru. Update sekarang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performUpdate(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _performUpdate(BuildContext context) async {
    final provider = Provider.of<HewanProvider>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Mengupdate data...'),
          ],
        ),
      ),
    );

    try {
      await provider.syncPendingSubmissions();
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil diupdate'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal update data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}