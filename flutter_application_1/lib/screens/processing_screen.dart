import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'result_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final String? imagePath;
  final Uint8List? imageBytes;

  const ProcessingScreen({
    Key? key,
    this.imagePath,
    this.imageBytes,
  }) : super(key: key);

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  double _step1Progress = 0.0; 
  double _step2Progress = 0.0; 
  bool _step1Complete = false;
  bool _step2Active = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  // animasi bar 
  void _startAnimation() {
    // bar pertama
    Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _step1Progress = 0.5);
    });
    Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      setState(() {
        _step1Progress = 1.0;
        _step1Complete = true;
        _step2Active = true;
      });
    });

    // bar kedua
    Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      setState(() => _step2Progress = 0.33);
    });
    Timer(const Duration(milliseconds: 3100), () {
      if (!mounted) return;
      setState(() => _step2Progress = 0.66);
    });
    Timer(const Duration(milliseconds: 3800), () {
      if (!mounted) return;
      setState(() {
        _step2Progress = 1.0;
      });
    });

    // tampilkan result setelah animasi loading (4,5 detik)
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imagePath: widget.imagePath,
            imageBytes: widget.imageBytes,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red[50]!, Colors.pink[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'Memproses...',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Model CNN sedang menganalisis\nwarna dan tekstur strawberry',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              const SizedBox(height: 48),

              _buildProgressStep(
                'Ekstraksi Fitur',
                value: _step1Progress,
                isComplete: _step1Complete,
              ),
              const SizedBox(height: 12),

              _buildProgressStep(
                'Analisis CNN',
                value: _step2Progress,
                isActive: _step2Active && !_step1Progress.isNegative,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStep(String title, {double value = 0.0, bool isComplete = false, bool isActive = false}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isComplete)
                  const Icon(Icons.check_circle, color: Colors.green, size: 20)
                else if (isActive && value > 0 && value < 1)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                else if (value == 0)
                  Icon(Icons.circle_outlined, color: Colors.grey[300], size: 20)
                else
                  const Icon(Icons.circle, color: Colors.red, size: 20), 
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}