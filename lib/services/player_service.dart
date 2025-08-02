import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';

class PlayerService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  Song? get currentSong => _currentSong;
  PlayerState get playerState => _playerState;
  Duration get position => _position;
  Duration get duration => _duration;

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
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
      notifyListeners();
    });
  }

  Future<void> playSong(Song song) async {
    if (_currentSong?.id == song.id && _playerState == PlayerState.playing) {
      return;
    }

    _currentSong = song;
    await _audioPlayer.play(UrlSource(song.audioUrl));
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
    notifyListeners();
  }

  void disposePlayer() {
    _audioPlayer.dispose();
  }
}


/*
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/song_model.dart';

class PlayerService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  Song? get currentSong => _currentSong;
  PlayerState get playerState => _playerState;
  Duration get position => _position;
  Duration get duration => _duration;

  PlayerService() {
    _setupListeners();
    if (kIsWeb) {
      // Web-specific configuration
      _audioPlayer.setAudioContext(AudioContext(
        audio: AudioContextManager(
          // Required for web compatibility
          html: AudioContextHTML(
            shouldUseContext: true,
            latencyHint: AudioLatencyHint.playback,
          ),
        ),
      ));
    }
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
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
      notifyListeners();
    });
  }

  Future<void> playSong(Song song) async {
    if (_currentSong?.id == song.id && _playerState == PlayerState.playing) {
      return;
    }

    _currentSong = song;
    
    try {
      // Use a CORS-enabled audio source for web
      final source = kIsWeb 
          ? UrlSource(song.audioUrl.replaceFirst("http://", "https://"))
          : UrlSource(song.audioUrl);
      
      await _audioPlayer.play(source);
      notifyListeners();
    } catch (e) {
      debugPrint("Error playing song: $e");
      // Fallback to a known working audio source
      await _audioPlayer.play(UrlSource(
        "https://assets.mixkit.co/music/preview/mixkit-game-show-suspense-waiting-667.mp3"
      ));
    }
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
    notifyListeners();
  }

  void disposePlayer() {
    _audioPlayer.dispose();
  }
}

*/