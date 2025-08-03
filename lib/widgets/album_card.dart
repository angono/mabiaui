import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  final VoidCallback? onTap;

  const AlbumCard({super.key, required this.album, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album cover
            Hero(
              tag: 'album-${album.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  album.coverUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    width: 150,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.album,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150,
                      width: 150,
                      color: Colors.grey[900],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Album info
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    album.artist,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${album.year} • ${album.songCount} songs',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontSize: 11,
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
