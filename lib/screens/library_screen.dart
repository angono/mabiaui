import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Library')),
      body: ListView(
        children: [
          ListTile(title: Text('Favorites')),
          ListTile(title: Text('Playlists')),
          ListTile(title: Text('Albums')),
          ListTile(title: Text('Downloads')),
        ],
      ),
    );
  }
}
