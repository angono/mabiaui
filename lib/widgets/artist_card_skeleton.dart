import 'package:flutter/material.dart';

class ArtistCardSkeleton extends StatelessWidget {
  const ArtistCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withValues(alpha:0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Skeleton avatar
          Container(
            width: 60,
            height: 60,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
          ),

          // Skeleton text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 16,
                  color: Colors.grey[800],
                  margin: EdgeInsets.only(bottom: 8),
                ),
                Container(width: 80, height: 12, color: Colors.grey[800]),
              ],
            ),
          ),

          // Skeleton icon
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.favorite_border, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }
}
