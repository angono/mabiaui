import 'dart:ui';

class Genre {
  final String id;
  final String name;
  final String imageUrl;
  final String color; // Hex string (e.g. #FFCC00)
  // final int songCount;
  // final int artistCount;

  Genre({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.color,
    //  this.songCount,
    //  this.artistCount,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      color: json['color'] as String,
      // songCount: json['songCount'] as int,
      // artistCount: json['artistCount'] as int,
    );
  }

  /// Converts the [color] hex string to a Flutter [Color] object.
  Color get colorValue {
    final hex = color.replaceFirst('#', '');
    final buffer = StringBuffer();
    if (hex.length == 6) buffer.write('FF'); // add opacity if missing
    buffer.write(hex);
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
