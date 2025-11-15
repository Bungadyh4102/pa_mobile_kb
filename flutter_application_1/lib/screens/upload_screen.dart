import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'preview_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    setState(() => _isLoading = true);

    try {
      // mode web
      if (kIsWeb) {
        final XFile? webImage = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 1920,
          maxHeight: 1080,
        );

        if (webImage != null) {
          Uint8List bytes = await webImage.readAsBytes();

          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewScreen(
                  imageBytes: bytes,
                  imagePath: null,
                ),
              ),
            );
          }
        }
      } 
      // mode mobile
      else {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxWidth: 1920,
          maxHeight: 1080,
        );

        if (image != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewScreen(
                imagePath: image.path,
                imageBytes: null,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Gambar',
        style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _isLoading ? null : _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!, width: 4),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[50],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file, size: 60, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Klik untuk upload gambar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Format: JPG, PNG (Max 5MB)',
                                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // persyaratan gambar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, 
                border: Border.all(
                  color: Colors.blue[700]!, 
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Persyaratan Gambar:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black, 
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Gambar harus jelas dan fokus\n'
                          '• Satu strawberry per gambar\n'
                          '• Latar belakang kontras lebih baik\n'
                          '• Resolusi minimal 224x224 piksel',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87, 
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}