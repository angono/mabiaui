import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';
import 'package:mabiaui/services/now_playing_bar.dart';

class ArtistDetailScreen extends StatefulWidget {
  final Artist artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  late Future<List<Song>> _songsFuture;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _songsFuture = _dataService.getSongsByArtist(widget.artist.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.artist.imageUrl,
                fit: BoxFit.cover,
                color: const Color(0x77000000),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  widget.artist.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.artist.songCount} songs • ${widget.artist.genre}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 8),
                Text(
                  '5k followers',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 24),
                Text(
                  'Popular Songs',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: FutureBuilder<List<Song>>(
              future: _songsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const ListTile(
                        leading: CircleAvatar(radius: 24),
                        title: Text('Loading...'),
                      ),
                      childCount: 5,
                    ),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No songs available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                final songs = snapshot.data!;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          songs[index].coverUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        songs[index].title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        songs[index].album,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: Text(
                        songs[index].duration,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      onTap: () {
                        // Play song
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

/*
import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';
import 'package:provider/provider.dart';

class ArtistDetailScreen extends StatefulWidget {
  final Artist artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  late Future<List<Song>> _songsFuture;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _songsFuture = _dataService.getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.artist.name)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.artist.imageUrl,
                fit: BoxFit.cover,
                color: const Color(0x77000000),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  widget.artist.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.artist.songCount} songs • ${widget.artist.genre}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 24),
                Text(
                  'Popular Songs',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: FutureBuilder<List<Song>>(
              future: _songsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const ListTile(
                        leading: CircleAvatar(radius: 24),
                        title: Text('Loading...'),
                      ),
                      childCount: 5,
                    ),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No songs available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                // Filter songs by artist
                final songs = snapshot.data!
                    .where((song) => song.artist == widget.artist.name)
                    .toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final song = songs[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.coverUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        song.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        song.album,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: Text(
                        song.duration,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      onTap: () {
                        final playerService = Provider.of<PlayerService>(
                          context,
                          listen: false,
                        );
                        playerService.playSong(song);
                      },
                    );
                  }, childCount: songs.length),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      // bottomSheet: const NowPlayingBar(),
    );
  }
}

*/
