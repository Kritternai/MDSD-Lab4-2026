import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/destination.dart';
import '../models/saved_state.dart';
import '../widgets/destination_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Comment 1: ใช้ ListenableBuilder ฟังการเปลี่ยนแปลงของ SavedState.instance
    // เมื่อกดปุ่มหัวใจในหน้าอื่น (เช่น Explore หรือ Detail) หน้า SavedScreen จะถูก Rebuild และแสดงผลรายการล่าสุดทันที
    return ListenableBuilder(
      listenable: SavedState.instance,
      builder: (context, _) {
        // Comment 2: กรองรายการ Destination ที่มี ID อยู่ใน savedIds Set
        final savedDestinations = sampleDestinations
            .where((d) => SavedState.instance.isSaved(d.id))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('บันทึกไว้ (${savedDestinations.length})'),
            centerTitle: false,
          ),
          body: savedDestinations.isEmpty
              ? _buildEmptyState()
              : _buildSavedGrid(savedDestinations),
        );
      },
    );
  }

  // Comment 3: ใช้ LayoutBuilder ทำ Responsive Grid ให้รองรับหน้าจอทุกขนาดตาม M3 Window Size Classes
  Widget _buildSavedGrid(List<Destination> destinations) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 2; // Compact
        } else if (constraints.maxWidth < 840) {
          crossAxisCount = 3; // Medium
        } else if (constraints.maxWidth < 1200) {
          crossAxisCount = 4; // Expanded
        } else {
          crossAxisCount = 5; // Large (>= 1200 dp)
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemCount: destinations.length,
          itemBuilder: (context, index) {
            final destination = destinations[index];
            return DestinationCard(
              destination: destination,
              onTap: () {
                context.pushNamed(
                  'destination-detail',
                  pathParameters: {'id': destination.id},
                  extra: destination,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.pink.shade200),
          const SizedBox(height: 16),
          const Text(
            'ยังไม่มีรายการที่บันทึก',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'กดไอคอนรูปหัวใจบนสถานที่ท่องเที่ยวเพื่อบันทึกไว้ดูภายหลัง',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
