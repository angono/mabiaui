import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';

class ArtistDetailScreen extends StatefulWidget {
  final Artist artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  late Future<List<Song>> _songsFuture;
  late Future<List<Album>> _albumsFuture;
  final DataService _dataService = DataService();
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _songsFuture = _dataService.getSongsByArtist(widget.artist.id);
    _albumsFuture = _dataService.getAlbumsByArtist(widget.artist.id);

    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset > 100) {
          _appBarOpacity = 0.0;
        } else {
          _appBarOpacity = 1 - (_scrollController.offset / 100);
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<PlayerService>(context);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.artist.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.person,
                        size: 120,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                        stops: const [0.0, 0.3, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.artist.name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 32,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.8),
                                blurRadius: 6,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Updated to include albums count and followers
                        Text(
                          '${widget.artist.albumsCount} albums • ${widget.artist.songCount} songs • ${widget.artist.genre}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[300],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatNumber(widget.artist.followers)} followers',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final songs = await _songsFuture;
                        if (songs.isNotEmpty) {
                          playerService.setPlaylist(songs);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final songs = await _songsFuture;
                        if (songs.isNotEmpty) {
                          playerService.toggleShuffle();
                          playerService.setPlaylist(songs);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.shuffle, size: 24),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[700]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 24, bottom: 10),
                child: Text(
                  'Popular',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              FutureBuilder<List<Song>>(
                future: _songsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildSongsSkeleton();
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No songs available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final songs = snapshot.data!.take(5).toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: songs.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey[800], height: 1, indent: 72),
                    itemBuilder: (context, index) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          songs[index].coverUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 56,
                                height: 56,
                                color: Colors.grey[900],
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.white70,
                                ),
                              ),
                        ),
                      ),
                      title: Text(
                        songs[index].title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        songs[index].album,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        songs[index].duration,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      onTap: () {
                        playerService.setPlaylist(songs, startIndex: index);
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 32, bottom: 16),
                child: Text(
                  'Albums (${widget.artist.albumsCount})', // Added albums count
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              FutureBuilder<List<Album>>(
                future: _albumsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildAlbumsSkeleton();
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Center(
                        child: Text(
                          'No albums available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final albums = snapshot.data!;
                  return SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: albums.length,
                      itemBuilder: (context, index) => Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                albums[index].coverUrl,
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 140,
                                      height: 140,
                                      color: Colors.grey[900],
                                      child: const Icon(
                                        Icons.album,
                                        size: 50,
                                        color: Colors.white70,
                                      ),
                                    ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              albums[index].title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${albums[index].year} • ${albums[index].songCount} songs',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 80),
            ]),
          ),
        ],
      ),
      bottomSheet: _buildNowPlayingBar(playerService),
    );
  }

  // ... (Other methods remain the same: _buildSongsSkeleton, _buildAlbumsSkeleton,
  // _formatDuration, _formatNumber) ...

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

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Widget _buildSongsSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 120,
                        color: Colors.grey[800],
                      ),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 80, color: Colors.grey[800]),
                    ],
                  ),
                ),
                Container(height: 12, width: 40, color: Colors.grey[800]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumsSkeleton() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        itemBuilder: (context, index) => Container(
          width: 140,
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Container(height: 16, width: 100, color: Colors.grey[800]),
              const SizedBox(height: 4),
              Container(height: 12, width: 80, color: Colors.grey[800]),
            ],
          ),
        ),
      ),
    );
  }
}
