import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';

class MusicCard extends StatelessWidget {
  final Song song;
  final bool showPlayButton;
  final VoidCallback? onTap;

  const MusicCard({
    super.key,
    required this.song,
    this.showPlayButton = true,
    this.onTap,
  });

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
            // Album art with play button
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Album image
                Hero(
                  tag: 'album-${song.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      song.coverUrl,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        width: 150,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 40,
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

                // Play button overlay
                if (showPlayButton)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),

            // Song info
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        song.artist,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[400],
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "•",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        song.duration,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
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
