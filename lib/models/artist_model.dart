class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final String genre;
  final int songCount;
  final List<String>? albumIds;
  final int followers; // Add this field
  final int albumsCount; // Add this field

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genre,
    required this.songCount,
    this.albumIds,
    required this.followers,
    required this.albumsCount,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      genre: json['genre'] as String,
      songCount: json['songCount'] as int,
      albumsCount: json['albumIds']?.length ?? 0, // Calculate from albumIds
      followers: json['followers'] ?? 0,
      albumIds: List<String>.from(json['albumIds']),
    );
  }
}
