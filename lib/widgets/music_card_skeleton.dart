import 'package:flutter/material.dart';

class MusicCardSkeleton extends StatelessWidget {
  const MusicCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton album art
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8),
          // Skeleton title
          Container(width: 100, height: 16, color: Colors.grey[800]),
          const SizedBox(height: 4),
          // Skeleton artist
          Container(width: 80, height: 14, color: Colors.grey[800]),
        ],
      ),
    );
  }
}
