import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'processing_screen.dart';

class PreviewScreen extends StatelessWidget {
  final String? imagePath;      
  final Uint8List? imageBytes;  

  const PreviewScreen({
    Key? key,
    this.imagePath,
    this.imageBytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    String fileSize = '';

    // mode web
    if (kIsWeb) {
      imageWidget = Image.memory(
        imageBytes!,
        fit: BoxFit.contain,
        width: double.infinity,
      );
      fileSize = '${(imageBytes!.lengthInBytes / 1024).toStringAsFixed(1)} KB';
    }

    // mode mobile
    else {
      final file = File(imagePath!);
      imageWidget = Image.file(
        file,
        fit: BoxFit.contain,
        width: double.infinity,
      );
      int bytes = file.lengthSync();
      if (bytes < 1024) fileSize = '$bytes B';
      else if (bytes < 1024 * 1024) fileSize = '${(bytes / 1024).toStringAsFixed(1)} KB';
      else fileSize = '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratinjau Gambar'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imageWidget,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Detail gambar
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Gambar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailItem('Ukuran', fileSize),
                        _buildDetailItem('Status', '✓ Valid', color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // tombol mulai deteksi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProcessingScreen(
                        imagePath: imagePath,
                        imageBytes: imageBytes,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Mulai Deteksi',
                  style: TextStyle(fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}