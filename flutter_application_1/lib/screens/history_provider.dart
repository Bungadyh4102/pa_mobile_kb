import 'package:flutter/foundation.dart';
import 'detection_record.dart';

// Provider untuk menyimpan dan mengelola riwayat deteksi strawberry
class HistoryProvider with ChangeNotifier {
  final List<DetectionRecord> _records = [];

  List<DetectionRecord> get records => List.unmodifiable(_records);

  void addRecord(DetectionRecord record) {
    _records.insert(0, record);
    notifyListeners();
  }

  void clear() {
    _records.clear();
    notifyListeners();
  }
}
