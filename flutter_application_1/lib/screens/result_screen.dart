import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'detection_record.dart';
import 'history_provider.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final String? imagePath;
  final Uint8List? imageBytes;

  const ResultScreen({
    Key? key,
    this.imagePath,
    this.imageBytes,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, dynamic>? predictionResult;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _uploadAndPredict();
  }

  Future<void> _uploadAndPredict() async {
    // API
    const String apiUrl = 'https://mobile123.loca.lt/api/predict-image';

    try {
      final uri = Uri.parse(apiUrl);
      var request = http.MultipartRequest('POST', uri);

      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            widget.imageBytes!,
            filename: 'upload.jpg',
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('image', widget.imagePath!),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        setState(() {
          predictionResult = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal memproses gambar. Kode: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = kIsWeb
        ? Image.memory(widget.imageBytes!, height: 300, width: double.infinity, fit: BoxFit.cover)
        : Image.file(File(widget.imagePath!), height: 300, width: double.infinity, fit: BoxFit.cover);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Deteksi Strawberry'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : _buildResultBody(imageWidget),
    );
  }

  Widget _buildResultBody(Widget imageWidget) {
    final data = predictionResult?['data'] ?? {};
    final rawLabel = (data['Label'] ?? '-').toString();
    final accuracyStr = (data['Akurasi'] ?? '0%').toString();
    final warna = (data['Warna_dominan'] ?? '-').toString();
    final tekstur = (data['Texture'] ?? '-').toString();

    final ripeSet = {'ripe', 'matang', 'siap', 'ready'};

    String label = rawLabel.toLowerCase().trim();
    label = ripeSet.contains(label) ? 'ripe' : 'unripe';

    double confidencePercent = 0.0;
    try {
      confidencePercent = double.parse(accuracyStr.replaceAll(RegExp(r'[^\d.]'), '')).clamp(0.0, 100.0);
    } catch (e) {
      confidencePercent = 0.0;
    }

    double ripeBarValue;
    double unripeBarValue;

    if (label == 'ripe') {
      ripeBarValue = confidencePercent / 100.0;     
      unripeBarValue = 1.0 - ripeBarValue;          
    } else { 
      unripeBarValue = confidencePercent / 100.0;   
      ripeBarValue = 1.0 - unripeBarValue;          
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // gambar
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageWidget,
            ),
          ),
          const SizedBox(height: 16),

          // status
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: label == 'ripe'
                  ? const LinearGradient(colors: [Colors.green, Color(0xFF10b981)])
                  : const LinearGradient(colors: [Colors.orange, Colors.red]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  label == 'ripe' ? Icons.check_circle : Icons.warning,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 12),
                Text(
                  label == 'ripe' ? 'MATANG' : 'MENTAH',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  label == 'ripe'
                      ? 'Strawberry siap untuk dikonsumsi'
                      : 'Strawberry masih mentah',
                  style: const TextStyle(fontSize: 14, color: Color(0xFFd1fae5)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

            // UI 2 bar akurasi 
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tingkat Kepercayaan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildConfidenceBar('Matang (Ripe)', ripeBarValue, Colors.green),
                  const SizedBox(height: 12),
                  _buildConfidenceBar('Mentah (Unripe)', unripeBarValue, Colors.yellow[700]!),
                ],
              ),
            ),
          ),

          // detail deteksi
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analisis Detail',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Warna Dominan', warna),
                  const SizedBox(height: 12),
                  _buildDetailRow('Tekstur', tekstur),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // tombol
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Simpan Hasil',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSave() {
    if (predictionResult == null) return;

    final data = predictionResult!['data'];
    final rawLabel = (data['Label'] ?? '').toString();
    final accuracyStr = (data['Akurasi'] ?? '0%').toString();
    final warna = (data['Warna_dominan'] ?? '-').toString();
    final tekstur = (data['Texture'] ?? '-').toString();
    final ripeSet = {'ripe', 'matang', 'siap', 'ready'};

    String label = rawLabel.toLowerCase().trim();
    label = ripeSet.contains(label) ? 'ripe' : 'unripe';  

    double confidence = 0.0;
    try {
      confidence = double.parse(accuracyStr.replaceAll(RegExp(r'[^\d.]'), '')).clamp(0.0, 100.0);
    } catch (e) {
      confidence = 0.0;
    }

    Uint8List? imageBytes;
    if (kIsWeb) {
      imageBytes = widget.imageBytes;
    } else if (widget.imagePath != null) {
      try {
        imageBytes = File(widget.imagePath!).readAsBytesSync();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal baca gambar: $e')),
        );
        return;
      }
    }

    if (imageBytes == null) return;

    final record = DetectionRecord(
      imageBytes: imageBytes,
      label: label,
      confidence: confidence,
      dominantColor: warna,
      texture: tekstur,
    );

    // Simpan ke provider
    Provider.of<HistoryProvider>(context, listen: false).addRecord(record);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hasil berhasil disimpan ke Riwayat!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildConfidenceBar(String label, double value, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            Text('${(value * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 12,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }
}