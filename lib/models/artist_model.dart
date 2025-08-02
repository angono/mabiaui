class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final String genre;
  final int songCount;
  final List<String>? albumIds;

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genre,
    required this.songCount,
    this.albumIds,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      genre: json['genre'] as String,
      songCount: json['songCount'] as int,
      albumIds: json['albumIds'] != null
          ? List<String>.from(json['albumIds'])
          : null,
    );
  }
}
