import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:provider/provider.dart';

class GenreDetailScreen extends StatefulWidget {
  final Genre genre;

  const GenreDetailScreen({super.key, required this.genre});

  @override
  State<GenreDetailScreen> createState() => _GenreDetailScreenState();
}

class _GenreDetailScreenState extends State<GenreDetailScreen> {
  late Future<List<Song>> _songsFuture;
  late Future<List<Artist>> _artistsFuture;
  final DataService _dataService = DataService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _songsFuture = _dataService.getSongsByGenre(widget.genre.name);
    _artistsFuture = _dataService.getArtistsByGenre(widget.genre.name);

    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset > 100) {
        } else {}
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
    final genreColor = widget.genre.colorValue;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Genre image with color overlay
                  Image.network(
                    widget.genre.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: genreColor.withValues(alpha: 0.8)),
                  ),

                  // Gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          genreColor.withValues(alpha: 0.9),
                          Colors.transparent,
                          genreColor.withValues(alpha: 0.5),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),

                  // Genre name
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 60,
                    child: Text(
                      widget.genre.name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 36,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content area
          SliverList(
            delegate: SliverChildListDelegate([
              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Row(
                  children: [
                    // Play button
                    ElevatedButton(
                      onPressed: () async {
                        final songs = await _songsFuture;
                        if (songs.isNotEmpty) {
                          playerService.setPlaylist(songs);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.play_arrow, size: 28),
                    ),

                    const SizedBox(width: 16),

                    // Shuffle button
                    ElevatedButton(
                      onPressed: () async {
                        final songs = await _songsFuture;
                        if (songs.isNotEmpty) {
                          playerService.toggleShuffle();
                          playerService.setPlaylist(songs);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(
                        Icons.shuffle,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),

                    const Spacer(),

                    // More button
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),

              // Popular songs section
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
                child: Text(
                  'Popular in ${widget.genre.name}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),

              // Popular songs list
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
                        songs[index].artist,
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

              // Top artists section
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 32, bottom: 16),
                child: Text(
                  'Top Artists',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),

              // Top artists grid
              FutureBuilder<List<Artist>>(
                future: _artistsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildArtistsSkeleton();
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Center(
                        child: Text(
                          'No artists available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final artists = snapshot.data!.take(6).toList();
                  return SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: artists.length,
                      itemBuilder: (context, index) => Container(
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
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
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

              // Browse all section
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 32, bottom: 16),
                child: Text(
                  'Browse All',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),

              // Song grid
              FutureBuilder<List<Song>>(
                future: _songsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildSongsGridSkeleton();
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Center(
                        child: Text(
                          'No songs available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final songs = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1 / 1.4,
                        ),
                    itemCount: songs.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        playerService.setPlaylist(songs, startIndex: index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black54.withValues(alpha: 0.6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: Image.network(
                                songs[index].coverUrl,
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 120,
                                      color: Colors.grey[800],
                                      child: const Icon(
                                        Icons.music_note,
                                        size: 40,
                                        color: Colors.white70,
                                      ),
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    songs[index].title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    songs[index].artist,
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

  Widget _buildArtistsSkeleton() {
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
        ),
      ),
    );
  }

  Widget _buildSongsGridSkeleton() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1 / 1.4,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[800],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(height: 14, width: 100, color: Colors.grey[800]),
                  const SizedBox(height: 6),
                  Container(height: 12, width: 80, color: Colors.grey[800]),
                ],
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
}
