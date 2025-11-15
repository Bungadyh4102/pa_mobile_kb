import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/info_screen.dart';
import 'package:flutter_application_1/screens/setting_screen.dart';
import 'package:provider/provider.dart';
import 'detection_record.dart';
import 'history_provider.dart';

const List<String> _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
];

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Deteksi'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<HistoryProvider>(context, listen: false).clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Riwayat dibersihkan')),
              );
            },
            icon: const Icon(Icons.delete_sweep, color: Colors.red),
          ),
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, provider, child) {
          final records = provider.records;
          final sortedRecords = List<DetectionRecord>.from(records.reversed);
          return records.isEmpty ? _buildEmptyState() : _buildHistoryList(sortedRecords);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InfoScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.history, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Belum ada riwayat deteksi', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<DetectionRecord> records) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return _buildHistoryCard(record, index + 1);
      },
    );
  }

  Widget _buildHistoryCard(DetectionRecord record, int indexDisplay) {
    String cleanLabel = record.label.toLowerCase().trim();
    bool isRipe = cleanLabel == 'ripe'; 

    final status = isRipe ? 'Matang' : 'Mentah';
    final statusColor = isRipe ? Colors.green : Colors.yellow[700]!;
    final t = record.timestamp;
    final timeString = '${t.day} ${_monthNames[t.month - 1]} ${t.year}, '
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    return Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,  
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              record.imageBytes,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Strawberry #$indexDisplay',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    _buildStatusBadge(status, statusColor),
                  ],
                ),

                const SizedBox(height: 6),
                Text(timeString, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 10),

                _buildInfoRow('Confidence', '${record.confidence.toStringAsFixed(1)}%'),
                _buildInfoRow('Warna', record.dominantColor),
                _buildInfoRow('Tekstur', record.texture),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatusBadge(String status, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.4)),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}