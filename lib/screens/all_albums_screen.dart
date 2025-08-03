import 'package:flutter/material.dart';
import 'package:mabiaui/screens/screens.dart';

class AllAlbumsScreen extends StatefulWidget {
  const AllAlbumsScreen({super.key});

  @override
  State<AllAlbumsScreen> createState() => _AllAlbumsScreenState();
}

class _AllAlbumsScreenState extends State<AllAlbumsScreen> {
  late Future<List<Album>> _albumsFuture;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _albumsFuture = _dataService.getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Albums', style: TextStyle(fontSize: 18)),
      ),
      body: FutureBuilder<List<Album>>(
        future: _albumsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1 / 1.4,
                mainAxisSpacing: 10, // Spacing between items
                crossAxisSpacing: 10, // Spacing between rows
              ),
              itemCount: 8,
              itemBuilder: (context, index) => const AlbumCardSkeleton(),
            );
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No albums available',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          final albums = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1 / 1.4,
              mainAxisSpacing: 10, // Spacing between items
              crossAxisSpacing: 10, // Spacing between rows
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) => AlbumCard(
              album: albums[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AlbumDetailScreen(album: albums[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
