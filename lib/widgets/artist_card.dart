import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;

  const ArtistCard({
    super.key,
    required this.artist,
    required Null Function() onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistDetailScreen(artist: artist),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900]!.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Artist avatar
            Hero(
              tag: 'artist-${artist.id}',
              child: Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.purple.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    artist.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Artist info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    artist.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${artist.songCount} songs • ${artist.genre}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Favorite icon
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.favorite_border, color: Colors.grey, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
