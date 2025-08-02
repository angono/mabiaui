import 'package:flutter/material.dart';

class GenreCardSkeleton extends StatelessWidget {
  const GenreCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 20, width: 100, color: Colors.grey[800]),
        ],
      ),
    );
  }
}
