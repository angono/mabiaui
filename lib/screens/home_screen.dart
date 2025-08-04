import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';
import 'package:provider/provider.dart';

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
          // App bar with hero image
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Mabiaplay',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
              background: Image.network(
                'https://picsum.photos/1200/800?music',
                fit: BoxFit.cover,
                color: const Color(0x77000000),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),

          // Recently Played Section
          SliverPadding(
            padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Recently Played'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllSongsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'See All',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
            sliver: _buildRecentlyPlayedSliver(),
          ),

          // Popular Artists Section
          SliverPadding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Popular Artists'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllArtistsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'See All',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _buildPopularArtistsSliver(),
          ),

          // Popular Albums Section
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 32,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Popular Albums'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllAlbumsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'See All',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            sliver: _buildPopularAlbumsSliver(),
          ),

          // Popular Genres Section
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 32,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Popular Genres'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllGenresScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'See All',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            sliver: _buildPopularGenresSliver(),
          ),
          // Footer Spacer
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
      bottomSheet: _buildNowPlayingBar(playerService),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }

  Widget _buildNowPlayingBar(PlayerService playerService) {
    if (playerService.currentSong == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 70,
      color: Colors.grey[900],
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            playerService.currentSong!.coverUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          playerService.currentSong!.title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          playerService.currentSong!.artist,
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                playerService.playerState == PlayerState.playing
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
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
              icon: const Icon(Icons.skip_next, color: Colors.white),
              onPressed: () {
                // Skip to next song
              },
            ),
          ],
        ),
        onTap: () {
          // Navigate to now playing screen
        },
      ),
    );
  }

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
                itemBuilder: (context, index) => const MusicCardSkeleton(),
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
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.length,
              itemBuilder: (context, index) => MusicCard(
                song: songs[index],
                onTap: () {
                  final playerService = Provider.of<PlayerService>(
                    context,
                    listen: false,
                  );
                  playerService.playSong(songs[index]);
                },
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
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisExtent: 80,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => const ArtistCardSkeleton(),
              childCount: 6,
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              height: 200,
              alignment: Alignment.center,
              child: Text(
                'No artists available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        final artists = snapshot.data!.take(8).toList();
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisExtent: 80,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => ArtistCard(
              artist: artists[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ArtistDetailScreen(artist: artists[index]),
                  ),
                );
              },
            ),
            childCount: artists.length,
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
                itemBuilder: (context, index) => const AlbumCardSkeleton(),
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
              itemBuilder: (context, index) => AlbumCard(
                album: albums[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AlbumDetailScreen(album: albums[index]),
                    ),
                  );
                },
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
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) => const GenreCardSkeleton(),
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
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) => GenreCard(
                genre: genres[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GenreDetailScreen(genre: genres[index]),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
