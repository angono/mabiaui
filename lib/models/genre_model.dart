import 'dart:ui';

class Genre {
  final String id;
  final String name;
  final String imageUrl;
  final String color;

  Genre({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.color,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      color: json['color'] as String,
    );
  }

  Color get colorValue {
    // Convert hex color to Flutter Color
    return Color(int.parse(color.replaceFirst('#', '0xFF')));
  }
}
