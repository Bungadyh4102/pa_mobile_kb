import 'dart:typed_data';

// database lokal (tidak permanen)
class DetectionRecord {
  final Uint8List imageBytes;
  final String label;
  final double confidence;
  final String dominantColor;
  final String texture;
  final DateTime timestamp;

  DetectionRecord({
    required this.imageBytes,
    required this.label,
    required this.confidence,
    required this.dominantColor,
    required this.texture,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() =>
      'DetectionRecord(label: $label, confidence: $confidence, time: ${timestamp.toIso8601String()})';
}