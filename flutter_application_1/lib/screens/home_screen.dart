import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'camera_screen.dart';
import 'history_provider.dart';
import 'upload_screen.dart';
import 'history_screen.dart';
import 'info_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.redAccent],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'StrawberryCheck',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Deteksi kematangan strawberry Anda',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.red, size: 30),
                  ),
                ],
              ),
            ),
          ),

          // content
          Expanded(
            child: Consumer<HistoryProvider>(
              builder: (context, provider, _) {
                final records = provider.records;
                final total = records.length;
                final matang = records.where((r) => r.label.toLowerCase() == 'ripe').length;
                final mentah = total - matang;

                // Ambil 2 data deteksi terbaru 
                final recent = List.from(records);
                recent.sort((a, b) => b.timestamp.compareTo(a.timestamp)); 
                final recentTwo = recent.length >= 2 ? recent.sublist(0, 2) : recent;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Metode Deteksi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  // tombol Kamera
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const CameraScreen(),
                                          ),
                                        ).then((_) => setState(() {}));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.red, width: 2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Column(
                                          children: [
                                            Icon(Icons.camera_alt, size: 40, color: Colors.red),
                                            SizedBox(height: 8),
                                            Text(
                                              'Kamera',
                                              style: TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // tombol Upload
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const UploadScreen(),
                                          ),
                                        ).then((_) => setState(() {}));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey, width: 2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(Icons.upload_file, size: 40, color: Colors.grey[600]),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Upload',
                                              style: TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // statistik
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.pink],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Statistik Hari Ini',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(total.toString(), 'Total Scan'),
                                _buildStatItem(matang.toString(), 'Matang'),
                                _buildStatItem(mentah.toString(), 'Mentah'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // riwayat terakhir
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Riwayat Terakhir',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              if (records.isEmpty)
                                const Text('Belum ada riwayat.', style: TextStyle(color: Colors.grey)),

                              // Tampilkan 2 data terbaru
                              ...recentTwo.asMap().entries.map((entry) {
                                final r = entry.value;
                                final indexDisplay = records.indexOf(r) + 1;
                                final isRipe = r.label.toLowerCase() == 'ripe';
                                final status = isRipe ? 'Matang' : 'Mentah';
                                final statusColor = isRipe ? Colors.green : Colors.yellow[700]!;
                                final minutesAgo = DateTime.now().difference(r.timestamp).inMinutes;
                                final textTime = minutesAgo == 0 ? 'Baru saja' : '$minutesAgo menit lalu';

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildHistoryItem(
                                      'Strawberry #$indexDisplay',
                                      textTime,
                                      status,
                                      statusColor,
                                      r.imageBytes,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
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

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.red[100],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String time, String status, Color statusColor, Uint8List imageBytes) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              imageBytes,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}