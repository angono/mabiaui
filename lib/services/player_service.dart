import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mabiaui/models/song_model.dart';

class PlayerService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = -1;
  Song? _currentSong;
  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isShuffle = false;
  bool _isRepeat = false;

  Song? get currentSong => _currentSong;
  PlayerState get playerState => _playerState;
  Duration get position => _position;
  Duration get duration => _duration;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;

  // Public stream for position changes
  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;

  PlayerService() {
    _setupListeners();
  }

  void _setupListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _position = position;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _handlePlaybackComplete();
    });

    // _audioPlayer.onPlayerError.listen((event) {
    //   debugPrint("Player error: $event");
    //   // Handle error (e.g., show snackbar)
    // });
  }

  void _handlePlaybackComplete() {
    if (_isRepeat) {
      // Repeat current song
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.resume();
    } else if (_currentIndex < _playlist.length - 1) {
      // Play next song
      skipNext();
    } else {
      // End of playlist
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
      notifyListeners();
    }
  }

  Future<void> playSong(Song song, {List<Song>? playlist}) async {
    if (playlist != null) {
      _playlist = playlist;
      _currentIndex = playlist.indexWhere((s) => s.id == song.id);
    } else if (_playlist.isEmpty) {
      _playlist = [song];
      _currentIndex = 0;
    }

    if (_currentIndex == -1) {
      _playlist.add(song);
      _currentIndex = _playlist.length - 1;
    }

    _currentSong = song;

    try {
      await _audioPlayer.play(UrlSource(song.audioUrl));
      notifyListeners();
    } catch (e) {
      debugPrint("Play error: $e");
      // Handle playback error
    }
  }

  Future<void> setPlaylist(List<Song> songs, {int startIndex = 0}) async {
    if (songs.isEmpty) return;

    _playlist = songs;
    _currentIndex = startIndex.clamp(0, songs.length - 1);
    await playSong(songs[_currentIndex]);
  }

  Future<void> skipNext() async {
    if (_playlist.isEmpty) return;

    int nextIndex;
    if (_isShuffle) {
      nextIndex = _getRandomIndex();
    } else {
      nextIndex = (_currentIndex + 1) % _playlist.length;
    }

    await playSong(_playlist[nextIndex]);
  }

  Future<void> skipPrevious() async {
    if (_playlist.isEmpty) return;

    int prevIndex;
    if (_isShuffle) {
      prevIndex = _getRandomIndex();
    } else {
      prevIndex = (_currentIndex - 1) % _playlist.length;
      if (prevIndex < 0) prevIndex = _playlist.length - 1;
    }

    await playSong(_playlist[prevIndex]);
  }

  int _getRandomIndex() {
    if (_playlist.length <= 1) return 0;
    int newIndex;
    do {
      newIndex = DateTime.now().millisecondsSinceEpoch % _playlist.length;
    } while (newIndex == _currentIndex);
    return newIndex;
  }

  Future<void> toggleShuffle() async {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    notifyListeners();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
    notifyListeners();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSong = null;
    _position = Duration.zero;
    _currentIndex = -1;
    notifyListeners();
  }

  void disposePlayer() {
    _audioPlayer.dispose();
  }
}
