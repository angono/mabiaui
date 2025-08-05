import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';
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
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _songsFuture = _dataService.getSongsByAlbum(widget.album.id);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final double offset = _scrollController.offset;
    setState(() {
      _appBarOpacity = (offset / 100).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<PlayerService>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.lerp(
          Colors.transparent,
          const Color(0xFF121212),
          _appBarOpacity,
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.45,
            floating: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.album.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.album,
                        color: Colors.white70,
                        size: 80,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF121212).withValues(alpha: 0.7),
                          const Color(0xFF121212),
                        ],
                        stops: const [0.4, 0.75, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 48,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.album.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 28,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.album.artist,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${widget.album.year} • ${widget.album.songCount} songs • ${widget.album.genre}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.favorite_border, color: Colors.green),
                      const SizedBox(width: 16),
                      Icon(Icons.downloading, color: Colors.grey[400]),
                      const SizedBox(width: 16),
                      Icon(Icons.more_vert, color: Colors.grey[400]),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.1,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shuffle, color: Colors.green[400]),
                              const SizedBox(width: 8),
                              Text(
                                'Shuffle Play',
                                style: TextStyle(
                                  color: Colors.green[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF121212),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Tracklist',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
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
                      (context, index) => Container(
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          title: Container(
                            height: 16,
                            width: 120,
                            color: Colors.grey[800],
                          ),
                        ),
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
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final isCurrent =
                        playerService.currentSong?.id == songs[index].id;
                    return InkWell(
                      onTap: () {
                        playerService.setPlaylist(songs, startIndex: index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? Colors.grey.withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrent
                                      ? Colors.green
                                      : Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    songs[index].title,
                                    style: TextStyle(
                                      color: isCurrent
                                          ? Colors.green
                                          : Colors.white,
                                      fontSize: 16,
                                      fontWeight: isCurrent
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    songs[index].duration,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: songs.length),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomSheet: _buildNowPlayingBar(playerService),
    );
  }

  Widget _buildNowPlayingBar(PlayerService playerService) {
    if (playerService.currentSong == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 72,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF282828).withValues(alpha: 0.8),
            const Color(0xFF121212),
          ],
        ),
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
                    ? Icons.pause
                    : Icons.play_arrow,
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
            const SizedBox(width: 8),
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
            backgroundColor: Colors.transparent,
            builder: (context) => _buildNowPlayingSheet(playerService),
          );
        },
      ),
    );
  }

  Widget _buildNowPlayingSheet(PlayerService playerService) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF282828), Color(0xFF121212)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Mini player handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Album art
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              playerService.currentSong!.coverUrl,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            playerService.currentSong!.artist,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 24),

          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder<Duration>(
              stream: playerService.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = playerService.duration;
                // final duration = playerService.duration ?? Duration.zero;

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.green,
                        inactiveTrackColor: Colors.grey.shade800,
                        thumbColor: Colors.white,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        trackHeight: 3,
                      ),
                      child: Slider(
                        value: position.inSeconds.toDouble(),
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          playerService.seek(Duration(seconds: value.toInt()));
                        },
                      ),
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
          const SizedBox(height: 32),

          // Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shuffle,
                    size: 28,
                    color: playerService.isShuffle
                        ? Colors.green
                        : Colors.grey[400],
                  ),
                  onPressed: playerService.toggleShuffle,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    size: 32,
                    color: Colors.white,
                  ),
                  onPressed: playerService.skipPrevious,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: IconButton(
                    icon: Icon(
                      playerService.playerState == PlayerState.playing
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 42,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      if (playerService.playerState == PlayerState.playing) {
                        playerService.pause();
                      } else {
                        playerService.resume();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    size: 32,
                    color: Colors.white,
                  ),
                  onPressed: playerService.skipNext,
                ),
                IconButton(
                  icon: Icon(
                    playerService.isRepeat ? Icons.repeat_on : Icons.repeat,
                    size: 28,
                    color: playerService.isRepeat
                        ? Colors.green
                        : Colors.grey[400],
                  ),
                  onPressed: playerService.toggleRepeat,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
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
