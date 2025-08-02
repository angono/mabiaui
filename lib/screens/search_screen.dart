import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search songs, artists...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView(
        children: [
          // Will implement search results later
        ],
      ),
    );
  }
}
