import 'package:flutter/material.dart';
import '../models/genre_model.dart';

class GenreCard extends StatelessWidget {
  final Genre genre;
  final VoidCallback? onTap;

  const GenreCard({super.key, required this.genre, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: genre.colorValue.withValues(alpha: 0.2),
                image: DecorationImage(
                  image: NetworkImage(genre.imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    genre.colorValue.withValues(alpha: 0.7),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  genre.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 10,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${genre.name} Music',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
