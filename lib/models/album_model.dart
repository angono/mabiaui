class Album {
  final String id;
  final String title;
  final String artist;
  final String year;
  final int songCount;
  final String coverUrl;
  final String genre;

  Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.songCount,
    required this.coverUrl,
    required this.genre,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      year: json['year'] as String,
      songCount: json['songCount'] as int,
      coverUrl: json['coverUrl'] as String,
      genre: json['genre'] as String,
    );
  }
}
