import 'package:flutter/material.dart';
import 'package:mabiaui/services/now_playing_bar.dart';
import 'package:provider/provider.dart';
import 'screens.dart';

class GenreDetailScreen extends StatefulWidget {
  final Genre genre;

  const GenreDetailScreen({super.key, required this.genre});

  @override
  State<GenreDetailScreen> createState() => _GenreDetailScreenState();
}

class _GenreDetailScreenState extends State<GenreDetailScreen> {
  late Future<List<Song>> _songsFuture;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _songsFuture = _dataService.getSongsByGenre(widget.genre.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.genre.imageUrl,
                    fit: BoxFit.cover,
                    color: widget.genre.colorValue.withValues(alpha: 0.7),
                    colorBlendMode: BlendMode.darken,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      widget.genre.name,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: FutureBuilder<List<Song>>(
              future: _songsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 1 / 1.4,
                          mainAxisSpacing: 10, // Spacing between items
                          crossAxisSpacing: 10, // Spacing between rows
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const MusicCardSkeleton(),
                      childCount: 6,
                    ),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No songs available for this genre',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                final songs = snapshot.data!;
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1 / 1.4,
                    mainAxisSpacing: 10, // Spacing between items
                    crossAxisSpacing: 10, // Spacing between rows
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => MusicCard(
                      song: songs[index],
                      onTap: () {
                        final playerService = Provider.of<PlayerService>(
                          context,
                          listen: false,
                        );
                        playerService.playSong(songs[index]);
                      },
                    ),
                    childCount: songs.length,
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomSheet: const NowPlayingBar(),
    );
  }
}
