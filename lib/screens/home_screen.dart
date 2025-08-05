import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Song>> _songsFuture;
  late Future<List<Artist>> _artistsFuture;
  late Future<List<Album>> _albumsFuture;
  late Future<List<Genre>> _genresFuture;

  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _songsFuture = _dataService.getSongs();
    _artistsFuture = _dataService.getArtists();
    _albumsFuture = _dataService.getAlbums();
    _genresFuture = _dataService.getGenres();
  }

  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<PlayerService>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/cover.webp',
                    height: MediaQuery.of(context).size.width * 0.6,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.transparent,
                          Colors.purple.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Mabiaplay',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          // Recently Played Section
          _buildSectionHeader('Recently played', '/all-songs'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: _buildRecentlyPlayedSliver(),
          ),

          // Popular Artists Section
          _buildSectionHeader('Popular artists', '/all-artists'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: _buildPopularArtistsSliver(),
          ),

          // Popular Albums Section
          _buildSectionHeader('Popular albums', '/all-albums'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: _buildPopularAlbumsSliver(),
          ),

          // Popular Genres Section
          _buildSectionHeader('Popular genres', '/all-genres'),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 32,
              top: 8,
            ),
            sliver: _buildPopularGenresSliver(),
          ),
        ],
      ),
      bottomSheet: _buildNowPlayingBar(playerService),
    );
  }

  Widget _buildSectionHeader(String title, String routeName) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, routeName),
              child: Text(
                'See all',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNowPlayingBar(PlayerService playerService) {
    if (playerService.currentSong == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        border: Border(
          top: BorderSide(color: Colors.grey.shade800, width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            playerService.currentSong!.coverUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 48,
              height: 48,
              color: Colors.grey[800],
              child: const Icon(Icons.music_note, color: Colors.white),
            ),
          ),
        ),
        title: Text(
          playerService.currentSong!.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          playerService.currentSong!.artist,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                playerService.playerState == PlayerState.playing
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                if (playerService.playerState == PlayerState.playing) {
                  playerService.pause();
                } else {
                  playerService.resume();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.white, size: 28),
              onPressed: playerService.skipNext,
            ),
          ],
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => _buildNowPlayingSheet(playerService),
          );
        },
      ),
    );
  }

  Widget _buildNowPlayingSheet(PlayerService playerService) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Mini player handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Album art
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              playerService.currentSong!.coverUrl,
              width: 240,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 240,
                height: 240,
                color: Colors.grey[800],
                child: const Icon(Icons.album, size: 80, color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Song info
          Text(
            playerService.currentSong!.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            playerService.currentSong!.artist,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 20),

          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder<Duration>(
              stream: playerService.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = playerService.duration;

                return Column(
                  children: [
                    Slider(
                      value: position.inSeconds.toDouble(),
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        playerService.seek(Duration(seconds: value.toInt()));
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                      inactiveColor: Colors.grey.shade800,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  size: 32,
                  color: Colors.white,
                ),
                onPressed: playerService.skipPrevious,
              ),
              const SizedBox(width: 28),
              IconButton(
                icon: Icon(
                  playerService.playerState == PlayerState.playing
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 62,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  if (playerService.playerState == PlayerState.playing) {
                    playerService.pause();
                  } else {
                    playerService.resume();
                  }
                },
              ),
              const SizedBox(width: 28),
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  size: 32,
                  color: Colors.white,
                ),
                onPressed: playerService.skipNext,
              ),
            ],
          ),

          // Playback modes
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  playerService.isShuffle ? Icons.shuffle_on : Icons.shuffle,
                  color: playerService.isShuffle
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                ),
                onPressed: playerService.toggleShuffle,
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: Icon(
                  playerService.isRepeat ? Icons.repeat_on : Icons.repeat,
                  color: playerService.isRepeat
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                ),
                onPressed: playerService.toggleRepeat,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  // ... [Rest of the methods remain the same] ...

  // ... [Keep the rest of the methods: _buildRecentlyPlayedSliver,
  // _buildPopularArtistsSliver, _buildPopularAlbumsSliver,
  // _buildPopularGenresSliver, _getGenreColor, and skeleton widgets] ...

  Widget _buildRecentlyPlayedSliver() {
    return FutureBuilder<List<Song>>(
      future: _songsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) => const _MusicCardSkeleton(),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'No songs available',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          );
        }

        final songs = snapshot.data!.take(8).toList();
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  final playerService = Provider.of<PlayerService>(
                    context,
                    listen: false,
                  );
                  playerService.setPlaylist(songs, startIndex: index);
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          songs[index].coverUrl,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        songs[index].title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        songs[index].artist,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopularArtistsSliver() {
    return FutureBuilder<List<Artist>>(
      future: _artistsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) => const _ArtistCardSkeleton(),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  'No artists available',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ),
            ),
          );
        }

        final artists = snapshot.data!.take(8).toList();
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: artists.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ArtistDetailScreen(artist: artists[index]),
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.grey.shade800,
                              Colors.grey.shade900,
                            ],
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            artists[index].imageUrl,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        artists[index].name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopularAlbumsSliver() {
    return FutureBuilder<List<Album>>(
      future: _albumsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) => const _AlbumCardSkeleton(),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 230,
              child: Center(
                child: Text(
                  'No albums available',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          );
        }

        final albums = snapshot.data!.take(8).toList();
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: albums.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AlbumDetailScreen(album: albums[index]),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          albums[index].coverUrl,
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        albums[index].title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        albums[index].artist,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopularGenresSliver() {
    return FutureBuilder<List<Genre>>(
      future: _genresFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) => const _GenreCardSkeleton(),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'No genres available',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          );
        }

        final genres = snapshot.data!;
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GenreDetailScreen(genre: genres[index]),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: _getGenreColor(index),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      genres[index].name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getGenreColor(int index) {
    final colors = [
      const Color(0xFF1DB954), // Spotify green
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF2196F3), // Blue
      const Color(0xFFE91E63), // Pink
      const Color(0xFFFF9800), // Orange
      const Color(0xFF4CAF50), // Green
    ];
    return colors[index % colors.length];
  }
}

// Skeleton Loading Widgets
class _MusicCardSkeleton extends StatelessWidget {
  const _MusicCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 16, width: 100, color: Colors.grey[800]),
          const SizedBox(height: 4),
          Container(height: 14, width: 80, color: Colors.grey[800]),
        ],
      ),
    );
  }
}

class _ArtistCardSkeleton extends StatelessWidget {
  const _ArtistCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF282828),
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 16, width: 100, color: const Color(0xFF282828)),
        ],
      ),
    );
  }
}

class _AlbumCardSkeleton extends StatelessWidget {
  const _AlbumCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 16, width: 120, color: Colors.grey[800]),
          const SizedBox(height: 4),
          Container(height: 14, width: 100, color: Colors.grey[800]),
        ],
      ),
    );
  }
}

class _GenreCardSkeleton extends StatelessWidget {
  const _GenreCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
