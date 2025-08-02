import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';
import 'package:mabiaui/services/now_playing_bar.dart';

class AlbumDetailScreen extends StatefulWidget {
  final Album album;

  const AlbumDetailScreen({super.key, required this.album});

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  late Future<List<Song>> _songsFuture;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _songsFuture = _dataService.getSongsByAlbum(widget.album.id);
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
                widget.album.coverUrl,
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
                  widget.album.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.album.artist,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.album.year} • ${widget.album.songCount} songs • ${widget.album.genre}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tracklist',
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
                      childCount: widget.album.songCount,
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
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),
                      title: Text(
                        songs[index].title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        songs[index].duration,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        onPressed: () {},
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
import 'package:mabiaui/services/now_playing_bar.dart';
import 'package:provider/provider.dart';

class AlbumDetailScreen extends StatefulWidget {
  final Album album;

  const AlbumDetailScreen({super.key, required this.album});

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
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
      // appBar: AppBar(title: Text(widget.album.title)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.album.coverUrl,
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
                  widget.album.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.album.artist,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.album.year} • ${widget.album.songCount} songs • ${widget.album.genre}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tracklist',
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
                      childCount: widget.album.songCount,
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

                // Filter songs by album
                final songs = snapshot.data!
                    .where((song) => song.album == widget.album.title)
                    .toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final song = songs[index];
                    return ListTile(
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),
                      title: Text(
                        song.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        song.duration,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        onPressed: () {},
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
      bottomSheet: const NowPlayingBar(),
    );
  }
}

*/
