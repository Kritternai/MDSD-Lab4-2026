import 'package:flutter/material.dart';

// Comment 1: Single Source of Truth (Singleton + ChangeNotifier)
// ใช้ Singleton Pattern ร่วมกับ ChangeNotifier เพื่อจัดการ State รายการที่ถูกบันทึก (Saved IDs) ข้ามหน้า
// โดยไม่ต้องพึ่งพา State Management Library ภายนอก ทำให้ทุกหน้า (Explore, Detail, Saved) เข้าถึงและอัปเดตข้อมูลชุดเดียวกันได้ทันที
class SavedState extends ChangeNotifier {
  static final SavedState instance = SavedState._internal();
  SavedState._internal();

  // กำหนดรายการเริ่มต้นให้บันทึก ID '1' (กรุงเทพฯ) และ '4' (โตเกียว) ไว้ล่วงหน้าเพื่อแสดงผลในเดโม
  final Set<String> _savedIds = {'1', '4'};

  Set<String> get savedIds => _savedIds;

  bool isSaved(String id) => _savedIds.contains(id);

  void toggleSave(String id) {
    if (_savedIds.contains(id)) {
      _savedIds.remove(id);
    } else {
      _savedIds.add(id);
    }
    // แจ้งเตือน Widget ทุกตัวที่ฟังค่านี้อยู่ให้ Rebuild หน้าจอทันที
    notifyListeners();
  }
}
