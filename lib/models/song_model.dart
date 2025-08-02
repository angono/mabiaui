class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String duration;
  final String coverUrl;
  final String genre;
  final String audioUrl; // Add this field
  final String artistId; // Add artist ID reference
  final String albumId; // Add album ID reference

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.coverUrl,
    required this.genre,
    required this.audioUrl, // Add to constructor
    required this.artistId,
    required this.albumId,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String,
      duration: json['duration'] as String,
      coverUrl: json['coverUrl'] as String,
      genre: json['genre'] as String,
      audioUrl: json['audioUrl'] as String, // Add to fromJson
      artistId: json['artistId'] as String,
      albumId: json['albumId'] as String,
    );
  }
}
